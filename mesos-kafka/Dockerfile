FROM datastrophic/mesos-java:1.1.0

ENV MESOS_KAFKA_VERSION=0.10.0.0
ENV KAFKA_VERSION=0.10.0.0

RUN mkdir -p /kafka-mesos
WORKDIR /kafka-mesos
RUN curl -O -k -L https://github.com/datastrophic/kafka/releases/download/$MESOS_KAFKA_VERSION/kafka-mesos-$KAFKA_VERSION.jar
RUN curl -O http://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.11-$KAFKA_VERSION.tgz
ADD entrypoint.sh /kafka-mesos/entrypoint.sh

CMD ["/kafka-mesos/entrypoint.sh"]