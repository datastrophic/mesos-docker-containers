#!/bin/bash

${DRILL_HOME}/bootstrap.sh

if [ $# -gt 0 ]; then
    exec "$@"
fi

${DRILL_HOME}/bin/drillbit.sh --config ${DRILL_HOME}/conf start && tail -f /apache-drill/log/drillbit.logdo