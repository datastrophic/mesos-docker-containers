#!/bin/bash
#This script is work in progress and will be changed in future
for k in `env | grep ^SPARK_ | cut -d= -f1`; do
    eval v=\$$k
    CMD="$CMD `echo $k | cut -d_ -f2- | tr '[:upper:]' '[:lower:]' | tr '_' '.'`=$v"
done

echo "properties found:"
echo $CMD

if [ $# -gt 0 ]; then
    exec "$@"
fi

exec "/zeppelin/bin/zeppelin.sh"
