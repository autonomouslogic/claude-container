FROM autonomouslogic/base-image:1.3.2

COPY ext/install.sh /claude-container/

ENV PATH="/root/.local/bin:$PATH"

# renovate: datasource=npm depName=@anthropic-ai/claude-code
ENV CLAUDE_CODE_VERSION=2.1.270
RUN cd /claude-container && ./install.sh ${CLAUDE_CODE_VERSION}

ENTRYPOINT ["claude"]
