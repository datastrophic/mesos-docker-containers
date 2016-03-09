FROM datastrophic/mesos:0.27.1

#installing utils and OpenJDK
RUN apt-get update && apt-get install -y curl apt-transport-https ca-certificates apparmor openjdk-7-jre-headless

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

#installing Docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-engine && service docker start

ENV MESOS_CONTAINERIZERS docker,mesos
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

ENTRYPOINT ["mesos-slave"]