# AGENTS.md

Guidance for AI coding agents working in this repository.

**Read [Readme.md](Readme.md) first.** It covers what the project is, installation and usage, limitations,
the contribution policy (including where new tools belong), and licensing.
This file only adds what the Readme doesn't cover. Don't copy Readme content into other files.

## Repository map

- `claude`: host-side wrapper script that users put on their `PATH`. It runs the image with `docker run`.
  It is distributed separately from the image (symlink or `curl`, see Readme).
- `Dockerfile`: the image. It is `autonomouslogic/base-image` plus Claude Code, installed by the native installer
  at the version in `CLAUDE_CODE_VERSION`. The entrypoint is `claude`.
- `ext/install.sh`: vendored copy of Anthropic's installer (`https://claude.ai/install.sh`).
- `Makefile`: `make load-scripts` refreshes `ext/install.sh`. `make docker` builds `autonomouslogic/claude-container:latest` locally.
- `publish.sh`: used only by the release. It builds the image, tags it `<version>` and `latest`, and pushes both to Docker Hub.
- `.releaserc`: semantic-release config. `CHANGELOG.md` is generated.
- `renovate.json`: Renovate config, extends `github>autonomouslogic/renovate-config`.
- `.github/workflows/`: `build.yml` (image build and `--version` smoke test on every push and PR),
  `semantic-pr.yml` (PR title lint), `update-install-script.yml` (daily installer refresh).

Readme files are named `Readme.md`, not `README.md`.

## Wrapper/image contract

The wrapper and the image ship independently. Users who installed the wrapper with `curl` never update it,
while the image updates on every launch (`--pull always` on `:latest`).
A new image must keep working with old copies of the wrapper. They rely on these points:

- The container runs as root with `HOME=/root`. Claude Code is in `/root/.local/bin`, hence the `PATH` line in the Dockerfile.
- Host `~/.claude` and `~/.claude.json` are mounted at `/root/.claude` and `/root/.claude.json`,
  so auth, settings, plugins, and session history persist between runs and live in the host's `~/.claude`.
- The current directory is mounted at the **same absolute path** and used as the working directory.
  This keeps paths identical to a native run, including Claude's per-project state under `~/.claude/projects/<path>`.
  Don't switch to a fixed mount point like `/workspace`.
- Arguments pass through unchanged (`"$@"`) to the `claude` entrypoint. The wrapper interprets nothing.
- `--rm` means anything written outside the mounts is gone after exit, such as packages installed during a session
  or files under `/root/.local`.

Changing the container user, `HOME`, or the entrypoint breaks existing wrappers.
Earlier non-root setups (`--user $(id -u):$(id -g)`, a dedicated user, a custom entrypoint script) were dropped;
see `git log -p -- claude Dockerfile`.
Because the container runs as root, files written to the project directory become root-owned on Linux hosts with rootful Docker.
Don't change the user model without the maintainer's agreement.

Wrapper rules:

- Keep it self-contained. The Readme promises a single file, so don't source other repo files or add config files.
- Keep it transparent: `claude` in the container should feel like native `claude`.
  Don't add wrapper-level options or workflow features unless asked (the Readme's Contributing section explains why).
- It runs on users' hosts, including macOS where `/bin/bash` is 3.2. Avoid bash 4+ features.
- If you change mounts or flags, update the Readme's Usage and Limitations sections.

## Dockerfile rules

- Renovate bumps `CLAUDE_CODE_VERSION` through a regex custom manager in `renovate.json`. It needs this exact two-line shape:
  ```dockerfile
  # renovate: datasource=npm depName=@anthropic-ai/claude-code
  ENV CLAUDE_CODE_VERSION=x.y.z
  ```
  Keep `ENV NAME=value` (not `ARG`, not `ENV NAME value`) directly below the comment with no blank line,
  or Renovate silently stops updating it. The version is looked up on npm even though installation uses the native installer.
- Keep the Claude Code install as the last layer and add new instructions above the `CLAUDE_CODE_VERSION` block.
  Claude Code bumps land almost daily and the wrapper pulls on every launch,
  so every user re-downloads any layer after the install after each release.
- Install Claude Code only through `ext/install.sh`. A global npm install and the devcontainer-feature script were tried first and replaced.
  The installer downloads the latest bootstrap binary, then runs `claude install <version>`.
  If Anthropic changes the installer's arguments, adjust the `RUN` line.
- Keep `FROM autonomouslogic/base-image:<x.y.z>` on an explicit tag; Renovate bumps it.
  New tools belong in base-image, not here (see Readme).
- Don't hard-code Claude Code or base-image versions in docs. They change almost daily.

## Vendored code (`ext/`)

`ext/install.sh` is a verbatim copy of `https://claude.ai/install.sh` and is licensed by Anthropic (see Readme).
Never edit or reformat it; refresh it with `make load-scripts`.
`update-install-script.yml` does this daily and commits `fix(deps): Updated Claude Code install script` straight to `main`,
which triggers a patch release.

## Commits, PRs, and releases

- Use Conventional Commits. PR titles are linted (`semantic-pr.yml`) and PRs are squash-merged,
  so the PR title becomes the commit that semantic-release reads.
  Maintainer style is `type: Capitalized summary`, for example `fix: Always pull` or `docs: Better installation instructions`.
  Scopes are only used as `(deps)`.
- The commit type decides whether a release happens (`.releaserc`, conventionalcommits preset):
  - `feat`: minor release. `fix`, `perf`, and `chore(deps)` (custom rule): patch release. Breaking change: major release.
  - `docs`, `ci`, `build`, `chore`, `refactor`, `style`, `test`: no release on their own.
    They appear in the next release's changelog.
- Every release rebuilds the image and pushes `:<version>` and `:latest`, which every user pulls on their next launch.
  There is no staging. Use `fix` or `feat` for wrapper or image changes users should receive
  (history uses `fix:` for wrapper changes even though the wrapper isn't in the image),
  and `build`, `ci`, `docs`, or `chore` for everything else.
- semantic-release runs outside this repo's GitHub Actions (`"ci": false`, no release workflow), on `main` only.
  Tags have no `v` prefix (`1.2.3`). Release commits are `chore(release): X.Y.Z [skip ci]` by `semantic-release-bot`.
- Never run `publish.sh` or semantic-release, create tags, bump versions, or edit `CHANGELOG.md` by hand.
- Most commits on `main` come from bots: Renovate and the release commits.
  Claude Code bumps are grouped separately, scheduled at any time, and automerged;
  other updates follow the shared org config. Expect `main` to move daily.

## Verifying changes

There is no test suite. CI (`build.yml`) only builds the image and runs `--version` in it.

- Shell scripts: `bash -n claude publish.sh`, plus `shellcheck` if available (it isn't in the image).
- Image, on a host with Docker: `make docker && docker run --rm autonomouslogic/claude-container:latest --version`.
  `make docker` tags `:latest`, and the wrapper's `--pull always` replaces that tag with the Docker Hub image on its next run.
  To use a local build interactively, run the wrapper's `docker run` line by hand without `--pull always`.
- Wrapper, on a host with Docker: run `./claude --version` from the repo. It uses the published image.

## When running inside this image

The maintainer uses this project to run Claude Code on itself, so you may be inside the container (`/.dockerenv` exists). In that case:

- There is no Docker daemon. The `docker` CLI comes with base-image, but no socket is mounted.
  You can't build or run images, so say so and leave image checks to CI or the user. Don't install or start a daemon.
- `claude` on `PATH` is the real CLI. `./claude` in the repo is the wrapper; don't run it here.
- Only `~/.claude`, `~/.claude.json`, and the project directory come from the host.
  There is no git identity, SSH key, or `gh` login, so the user commits and pushes from the host.

## Known sharp edges

Keep these in mind when touching related code. Fix them only when asked.

- Images are `linux/amd64` only: `publish.sh` uses a plain `docker build`, and base-image is amd64-only.
  arm64 support needs buildx in `publish.sh` and an arm64 base-image.
- On Linux, `-v` creates a missing host path as a root-owned directory, so a host without `~/.claude.json` gets a directory there.
- `-it` is hard-coded, so non-TTY use (for example `claude -p` in a pipe or cron job) fails.
- `update-install-script.yml` pushes with `GITHUB_TOKEN`, and those pushes don't trigger `build.yml`.
  Installer updates reach a release without a CI build.
- semantic-release pushes the tag and changelog commit before its publish step runs `publish.sh`.
  A failed image build leaves a release without an image.
- The container isolates the filesystem and processes, not the network (see the blog post linked from the Readme).
  `~/.claude` and the project directory are writable from inside, so anything the host later runs from them
  (git hooks, hooks in `~/.claude/settings.json`) runs outside the container. Don't overstate the isolation in docs.
- `semantic-pr.yml` uses `pull_request_target`, which runs with secrets. Never add a checkout of PR code to it.

Update this file when you change the wrapper contract, the release flow, or CI.
