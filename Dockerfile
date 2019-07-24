FROM openjdk:8u181-jre-stretch

LABEL MAINTAINER=shawnzhu@users.noreply.github.com

ENV PRESTO_VERSION=300
ENV PRESTO_HOME=/home/presto

# extra dependency for running launcher
RUN apt-get update && apt-get install -y --no-install-recommends \
		python2.7-minimal \
	&& rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python2.7 /usr/bin/python

RUN groupadd -g 999 presto && \
    useradd -r -u 999 -g presto --create-home --shell /bin/bash presto
#USER presto

COPY presto-server-316.tar /tmp/presto-server.tar
RUN cd $HOME && \
    mkdir 315 && \
    tar -xf /tmp/presto-server.tar --strip 1 -C 315 && \
    mkdir -p 315/data && \
    rm -f /tmp/presto-server.tar && \
    mv 315/* $PRESTO_HOME

COPY presto-db2.zip /tmp/presto-db2.zip 
RUN unzip /tmp/presto-db2.zip -d ${PRESTO_HOME}/plugin/ && \
    mv ${PRESTO_HOME}/plugin/presto-db2-${PRESTO_VERSION} ${PRESTO_HOME}/plugin/db2 && \
    rm -f /tmp/presto-db2.zip

COPY etc ${PRESTO_HOME}/etc
EXPOSE 8080

VOLUME ["${PRESTO_HOME}/etc", "${PRESTO_HOME}/data"]

WORKDIR ${PRESTO_HOME}

#ENTRYPOINT ["./bin/launcher"]
# purposely keep container alive
ENTRYPOINT ["tail", "-f", "/dev/null"]
#CMD ["run"]
