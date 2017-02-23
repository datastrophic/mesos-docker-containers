FROM ubuntu:xenial

ARG MESOS_VERSION=1.1.0-2.0.107.ubuntu1604

RUN echo "deb http://repos.mesosphere.com/ubuntu xenial main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
  apt-get -y update && \
  apt-get -y install curl mesos=${MESOS_VERSION} && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MESOS_WORK_DIR /tmp/mesos
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

VOLUME /tmp/mesos

VOLUME /var/log/mesos