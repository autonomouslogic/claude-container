.PHONY: load-scripts docker

load-scripts:
	wget -qO ext/install.sh https://raw.githubusercontent.com/anthropics/devcontainer-features/refs/heads/main/src/claude-code/install.sh
	chmod a+x ext/install.sh

docker:
	docker build \
		--pull \
		--tag autonomouslogic/claude-container:latest \
		-f Dockerfile \
		.

run: docker
	docker run -it autonomouslogic/claude-container:latest
