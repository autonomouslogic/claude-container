FROM autonomouslogic/base-image:1.3.2

COPY ext/install.sh /claude-container/
RUN ls -l /claude-container/
ENV PATH="/root/.local/bin:$PATH"
RUN cd /claude-container && ./install.sh

ENTRYPOINT ["claude"]
