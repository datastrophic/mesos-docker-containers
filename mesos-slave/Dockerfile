FROM datastrophic/mesos:1.1.0

#Docker
RUN apt-get update && apt-get install -y curl apt-transport-https ca-certificates lxc iptables apparmor && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get -y install curl docker-engine

ENV MESOS_CONTAINERIZERS docker,mesos
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

CMD ["mesos-slave", "--no-systemd_enable_support"]