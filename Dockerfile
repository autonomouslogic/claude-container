FROM autonomouslogic/base-image:1.3.2

LABEL maintainer="Kenneth Jørgensen <kenneth@autonomouslogic.com>" \
      name="claude-container" \
      org.opencontainers.image.title="Claude Container" \
      org.opencontainers.image.description="Docker container for running Claude Code CLI." \
      org.opencontainers.image.source="https://github.com/autonomouslogic/claude-container" \
      org.opencontainers.image.licenses="MIT-0"

COPY ext/install.sh /claude-container/

ENV PATH="/root/.local/bin:$PATH"

# renovate: datasource=npm depName=@anthropic-ai/claude-code
ENV CLAUDE_CODE_VERSION=2.1.276
RUN cd /claude-container && ./install.sh ${CLAUDE_CODE_VERSION}

ENTRYPOINT ["claude"]
