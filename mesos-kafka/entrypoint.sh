#!/bin/bash

set -e

jar='kafka-mesos*.jar'
CMD="java ${JVM_OPTS:--Xmx256m} -jar $jar "$@""
exec $CMD