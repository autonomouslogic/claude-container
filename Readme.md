# Claude Code Container
Run Claude Code in an isolated Docker container.

The main goal of this project is to provide a way to run Claude Code in a way that is as close as possible to
running it directly, but still containing it and all executions inside a Docker container.
See [this blog post](https://kennethjorgensen.com/blog/2026/isolating-claude-in-docker/) for more.

This is based on [base-image](https://github.com/autonomouslogic/base-image) which has a number of pre-installed tools.
That image is further based on [Containerbase](https://github.com/containerbase), which is based on Ubuntu.

## Usage
Clone the repo and symlink the executable:
```bash
git clone https://github.com/autonomouslogic/claude-container.git
ln -s claude-container/claude ~/.local/bin/claude
```
The run script will rarely change, but if it does, you can just run `git pull` on the repo.

Alternatively, you can download the script directly:
```bash
curl -s https://raw.githubusercontent.com/autonomouslogic/claude-container/refs/heads/main/claude > ~/.local/bin/claude
chmod a+x ~/.local/bin/claude
```

The executable file is self-contained.
Nothing else from the repo is needed.

Once installed, navigate to the directory you want to run Claude Code in and execute `claude` as normal.
Claude Code will now start inside a Docker container and you will be given a shell as normal.

## Limitations
There are a number of limitations inherent in running inside a Docker container:

* Only the current directory is accessible
* Only tools installed on the Docker image are available, see [base-image](https://github.com/autonomouslogic/base-image)

## Contributing
Contributions are very welcome.
This project was deliberately made as simple as possible to address the core need without changing the workflow.
If something doesn't work on your system, feel free to submit a PR.
If you want more development tools installed, submit a PR to [base-image](https://github.com/autonomouslogic/base-image).

## License
Code in _this repo_ is licensed under MIT-0.

Claude Code itself, as well as code in the `ext` directory, is owned by Anthropic and is licensed under different terms.

## Resources
Various resources used to set this up.

* https://code.claude.com/docs/en/overview
* https://code.claude.com/docs/en/devcontainer
  * https://github.com/anthropics/devcontainer-features 
* https://github.com/anthropics/claude-code/blob/main/.devcontainer/Dockerfile

## Other Projects
Alternative approaches to running Claude Code in containers.

* [Claudebox](https://github.com/RchGrav/claudebox) - also containerizes Claude Code, but adds its own opinionated workflow with pre-configured language and development profiles rather than being a transparent wrapper
* [claude-code-docker](https://github.com/gendosu/claude-code-docker) - a Docker image for Claude Code with multi-arch (amd64/arm64) support and Claude Desktop MCP server integration; image-first approach rather than a shell script wrapper
* [VibePod](https://github.com/VibePod/vibepod-cli) - containerizes multiple AI coding agents (not just Claude) with built-in metrics collection and an analytics dashboard
* [Herdr](https://herdr.dev/) - runs coding agents in persistent background sessions across machines rather than as interactive foreground processes
