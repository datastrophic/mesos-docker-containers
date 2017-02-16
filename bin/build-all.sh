#!/bin/bash

tag=$1
prefix=datastrophic

marathon_tag=1.3.6
chronos_tag=3.0.1
kafka_tag=0.10
spark_tag=2.1.0

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
home="$(dirname "$dir")"

if [ -z ${tag} ]
then
   echo "No tag provided, building with tag 'latest'"
   echo "To provide specific tag, invoke script with tag argument: build-all.sh <tag>"
   tag=latest
else
   echo "Starting build with tag $tag"
fi

#docker build --tag ${prefix}/mesos:${tag}                                  ${home}/mesos
#docker build --tag ${prefix}/mesos-java:${tag}                             ${home}/mesos-java
#docker build --tag ${prefix}/mesos-master:${tag}                           ${home}/mesos-master
#docker build --tag ${prefix}/mesos-slave:${tag}                            ${home}/mesos-slave
#docker build --tag ${prefix}/marathon:${marathon_tag}                      ${home}/marathon

if [ "$tag" = "latest" ]
then
   docker build --tag ${prefix}/chronos:${tag}       ${home}/chronos
   docker build --tag ${prefix}/mesos-kafka:${tag}   ${home}/mesos-kafka
   docker build --tag ${prefix}/mesos-spark:${tag}   ${home}/mesos-spark
else
   docker build --tag ${prefix}/chronos:mesos-${tag}-chronos-${chronos_tag}   ${home}/chronos
#   docker build --tag ${prefix}/mesos-kafka:mesos-${tag}-kafka-${kafka_tag}   ${home}/mesos-kafka
   docker build --tag ${prefix}/mesos-spark:mesos-${tag}-spark-${spark_tag}   ${home}/mesos-spark
fi