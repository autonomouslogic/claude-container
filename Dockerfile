FROM autonomouslogic/base-image:1.1.1

RUN mkdir /claude
COPY ext/install.sh /claude/
#RUN cd /claude && ./install.sh
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /
ENTRYPOINT bash
