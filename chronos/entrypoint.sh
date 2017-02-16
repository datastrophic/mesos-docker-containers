#!/bin/bash

set -e
CMD="java ${JVM_OPTS} -jar /chronos/chronos.jar $@"

# Parse environment variables (borrowed from https://github.com/mesoscloud/chronos)
for k in `set | grep ^CHRONOS_ | cut -d= -f1`; do
    eval v=\$$k
    CMD="$CMD --`echo $k | cut -d_ -f2- | tr '[:upper:]' '[:lower:]'` $v"
done

echo $CMD

if [ $# -gt 0 ]; then
    exec "$@"
fi

exec $CMD