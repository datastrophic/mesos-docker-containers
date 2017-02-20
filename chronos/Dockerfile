FROM datastrophic/mesos-java:1.1.0

ARG CHRONOS_VERSION=v3.0.1

RUN mkdir -p /chronos /chronos-build

#Installing software needed for the build
RUN apt-get update && apt-get install -y git maven curl build-essential && \
    curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs

#Building Chronos from release source (e.g. https://github.com/mesos/chronos/archive/3.0.0.tar.gz)
RUN cd /chronos-build && curl -Lo cronos-${CHRONOS_VERSION}.tar.gz https://github.com/mesos/chronos/archive/${CHRONOS_VERSION}.tar.gz && \
    tar -xzvf cronos-${CHRONOS_VERSION}.tar.gz --strip-components 1 && \
    mvn versions:set -DnewVersion=${CHRONOS_VERSION} && mvn package && cp target/chronos-${CHRONOS_VERSION}.jar /chronos/chronos.jar && \
    rm -rf /chronos-build /root/.m2 /root/.npm

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]