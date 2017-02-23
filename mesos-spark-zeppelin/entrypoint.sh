#!/bin/bash

#this script is created in parent image (mesos-spark) and performs spark-env variables parsing (e.g. SPARK_PUBLIC_DNS)
${SPARK_HOME}/bootstrap.sh

if [ $# -gt 0 ]; then
    exec "$@"
fi

exec "/zeppelin/bin/zeppelin.sh"
