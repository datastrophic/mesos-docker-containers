#!/bin/bash

CURRENT_IP=$(hostname -i)

mv ${SPARK_HOME}/conf/spark-env.sh.template ${SPARK_HOME}/conf/spark-env.sh

SPARK_LOCAL_IP=${SPARK_LOCAL_IP:-${CURRENT_IP:-"127.0.0.1"}}
SPARK_PUBLIC_DNS=${SPARK_PUBLIC_DNS:-${CURRENT_IP:-"127.0.0.1"}}

echo "SPARK_LOCAL_IP=$SPARK_LOCAL_IP" >> ${SPARK_HOME}/conf/spark-env.sh
echo "SPARK_PUBLIC_DNS=$SPARK_PUBLIC_DNS" >> ${SPARK_HOME}/conf/spark-env.sh

cat ${SPARK_HOME}/conf/spark-env.sh

exec "$@"
