#!/bin/bash

CURRENT_IP=$(hostname -i)

mv /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh

# echo "LIBPROCESS_IP=$CURRENT_IP" >> /opt/spark/conf/spark-env.sh
# echo "SPARK_LOCAL_IP=$CURRENT_IP" >> /opt/spark/conf/spark-env.sh

cat /opt/spark/conf/spark-env.sh

exec "$@"
