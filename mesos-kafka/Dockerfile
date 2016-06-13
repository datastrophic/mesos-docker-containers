FROM datastrophic/mesos-slave:0.28.1

ENV MESOS_KAFKA_VERSION=0.10.0.0
ENV KAFKA_VERSION=0.10.0.0

RUN mkdir -p /kafka-mesos
WORKDIR /kafka-mesos
RUN curl -O -k -L https://github.com/datastrophic/kafka/releases/download/$MESOS_KAFKA_VERSION/kafka-mesos-$KAFKA_VERSION.jar
RUN curl -O http://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.11-$KAFKA_VERSION.tgz
ADD kafka-mesos.sh /kafka-mesos/kafka-mesos.sh

ENTRYPOINT ["/kafka-mesos/kafka-mesos.sh"]