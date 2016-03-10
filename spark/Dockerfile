FROM datastrophic/mesos:0.27.1

RUN apt-get update && apt-get install -y curl && \
    mkdir -p /opt/spark /opt/spark-executor && \
    curl -o /opt/spark-executor/spark-1.6.0-bin-hadoop2.6.tgz http://apache.mirrors.spacedump.net/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz && \
    tar -xzf /opt/spark-executor/spark-1.6.0-bin-hadoop2.6.tgz -C /opt/spark --strip 1

ENV SPARK_EXECUTOR_URI=file:///opt/spark-executor/spark-1.6.0-bin-hadoop2.6.tgz

ENV SPARK_HOME /opt/spark
