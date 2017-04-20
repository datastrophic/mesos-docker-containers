FROM datastrophic/mesos-java:1.1.0

ARG DRILL_BINARY=apache-drill-1.10.0.tar.gz
ENV DRILL_HOME /apache-drill
ENV DRILL_JAVA_LIB_PATH ${DRILL_HOME}/native

RUN apt-get update && apt-get install -y curl && \
    mkdir -p ${DRILL_HOME} ${DRILL_JAVA_LIB_PATH} && \
    curl -o ${DRILL_HOME}/${DRILL_BINARY} http://apache.mirrors.hoobly.com/drill/drill-1.10.0/${DRILL_BINARY} && \
    tar -xzf ${DRILL_HOME}/${DRILL_BINARY} -C ${DRILL_HOME} --strip-components 1

ENV PATH=$PATH:$DRILL_HOME/bin

COPY conf/drill-override.conf ${DRILL_HOME}/conf
COPY conf/core-site.xml ${DRILL_HOME}/conf
COPY conf/drill-env.sh ${DRILL_HOME}/conf

COPY bootstrap.sh ${DRILL_HOME}
COPY entrypoint.sh /

#native auth library
COPY libjpam.so ${DRILL_JAVA_LIB_PATH}

EXPOSE 8047 31010 31011 31012

ENTRYPOINT ["/entrypoint.sh"]