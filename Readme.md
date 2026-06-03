# Claude Code Container
Run Claude Code in an isolated Docker container.

The main goal of this project is to provide a way to run Claude Code in a way that is as close as possible to
running it directly, but still containing it and all executions inside a Docker container.
See [this blog post](https://kennethjorgensen.com/blog/2026/isolating-claude-in-docker/) for more.

This is based on [base-image](https://github.com/autonomouslogic/base-image) which has a number of pre-installed tools.
That image is further based on [Containerbase](https://github.com/containerbase), which is based on Ubuntu.

## Usage
Copy the `claude` executable file into a path directory accessible by your shell, such as `~/.local/bin`.
The file is self-contained, so you can rename it, if you want.

Then simply navigate to the directory you want to run Claude Code in and execute `claude` as normal.
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
* [Claudebox](https://github.com/RchGrav/claudebox) - more complex with its own workflow
* https://github.com/gendosu/claude-code-docker - similar, but Node-specific
