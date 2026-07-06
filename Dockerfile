FROM autonomouslogic/base-image:1.2.3

COPY ext/install.sh /claude-container/
RUN ls -l /claude-container/
ENV PATH="/root/.local/bin:$PATH"
RUN cd /claude-container && ./install.sh

ENTRYPOINT ["claude"]
