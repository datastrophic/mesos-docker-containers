FROM datastrophic/mesos:0.28.1

#installing utils and OpenJDK
RUN apt-get update && apt-get install -y curl apt-transport-https ca-certificates lxc iptables apparmor openjdk-7-jre-headless

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

ENV MESOS_CONTAINERIZERS docker,mesos
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

ENTRYPOINT ["mesos-slave"]