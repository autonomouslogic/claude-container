FROM autonomouslogic/base-image:1.2.0

USER root

COPY ext/install.sh /claude-container/
RUN ls -l /claude-container/
ENV PATH="/root/.local/bin:$PATH"
RUN cd /claude-container && ./install.sh

RUN cp -L /root/.local/bin/claude /usr/local/bin/claude && \
    chmod 755 /usr/local/bin/claude && \
    rm -rf /root/.local/share/claude /root/.local/bin/claude
RUN /usr/local/bin/claude --version
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

#RUN useradd -m -s /bin/bash appuser && \
#    mkdir -p /home/appuser && \
#    chown -R appuser:appuser /home/appuser
#USER appuser

#WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["claude"]
#ENTRYPOINT ["pwd"]
#ENTRYPOINT ["ls", "-al", "/home/ubuntu"]
