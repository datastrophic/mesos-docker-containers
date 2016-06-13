FROM datastrophic/mesos:0.28.1

ENV CHRONOS_VERSION=2.4.0-0.1.20151007110204.ubuntu1404

RUN apt-get install --no-install-recommends -y chronos=$CHRONOS_VERSION

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

