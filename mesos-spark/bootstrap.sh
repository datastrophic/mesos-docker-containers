#!/bin/bash
#This script is work in progress and will be changed in future
DEFAULT_SPARK_DNS=$(hostname -i)

if [ ! -z "$SPARK_PUBLIC_DNS_EVAL" ]; then
   DEFAULT_SPARK_DNS=$($SPARK_PUBLIC_DNS_EVAL)
fi

SPARK_PUBLIC_DNS=${SPARK_PUBLIC_DNS:-${DEFAULT_SPARK_DNS:-"127.0.0.1"}}
echo "Using SPARK_PUBLIC_DNS=$SPARK_PUBLIC_DNS"

echo > ${SPARK_HOME}/conf/spark-env.sh
echo "SPARK_PUBLIC_DNS=$SPARK_PUBLIC_DNS" >> ${SPARK_HOME}/conf/spark-env.sh

echo "Contents of ${SPARK_HOME}/conf/spark-env.sh"
cat ${SPARK_HOME}/conf/spark-env.sh