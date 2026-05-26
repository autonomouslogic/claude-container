.PHONY: load-scripts docker

load-scripts:
	wget -qO ext/install.sh https://claude.ai/install.sh
	chmod a+x ext/install.sh

docker:
	docker build \
		--pull \
		--tag autonomouslogic/claude-container:latest \
		-f Dockerfile \
		.

run: docker
	docker run -it autonomouslogic/claude-container:latest
