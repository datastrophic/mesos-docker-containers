FROM datastrophic/mesos-java:1.1.0

ARG SPARK_BINARY=spark-2.1.0-bin-hadoop2.7.tgz

RUN apt-get update && apt-get install -y curl && \
    mkdir -p /spark && \
    curl -o /spark/${SPARK_BINARY} http://d3kbcqa49mib13.cloudfront.net/${SPARK_BINARY} && \
    tar -xzf /spark/${SPARK_BINARY} -C /spark --strip-components 1

ENV SPARK_HOME /spark
ENV PATH=$PATH:$SPARK_HOME/bin

COPY spark-defaults.conf /spark/conf
COPY entrypoint.sh /

EXPOSE 4040

ENTRYPOINT ["/entrypoint.sh"]