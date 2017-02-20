FROM datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0

ARG SPARK_NOTEBOOK_BINARY="spark-notebook-0.7.0-scala-2.11.8-spark-2.1.0-hadoop-2.7.3.tgz"

RUN mkdir -p /spark-notebook && \
    curl -Ls -o /spark-notebook/${SPARK_NOTEBOOK_BINARY} https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/${SPARK_NOTEBOOK_BINARY}?max-keys=100000 && \
    tar -xzf /spark-notebook/${SPARK_NOTEBOOK_BINARY} -C /spark-notebook --strip-components 1

#COPY clusters /spark-notebook/conf/clusters
COPY entrypoint.sh /

EXPOSE 9001

WORKDIR /spark-notebook
CMD ["/spark-notebook/bin/spark-notebook"]