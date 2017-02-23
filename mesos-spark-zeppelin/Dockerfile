FROM datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0

ARG ZEPPELIN_BINARY="zeppelin-0.7.0-bin-netinst.tgz"

RUN mkdir -p /zeppelin && \
    curl -Ls -o /zeppelin/${ZEPPELIN_BINARY} http://apache.mirrors.spacedump.net/zeppelin/zeppelin-0.7.0/${ZEPPELIN_BINARY} && \
    tar -xzf /zeppelin/${ZEPPELIN_BINARY} -C /zeppelin --strip-components 1

EXPOSE 8080

WORKDIR /zeppelin

COPY shiro.ini /zeppelin/conf
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]