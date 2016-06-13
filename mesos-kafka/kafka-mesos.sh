#!/bin/bash

set -e
jar='kafka-mesos*.jar'
java ${JVM_OPTS:--Xmx256m} -jar $jar "$@"