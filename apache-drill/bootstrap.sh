#!/bin/bash
sed -i -e "s/CLUSTER_ID/${CLUSTER_ID}/" /apache-drill/conf/drill-override.conf
sed -i -e "s/ZK_SERVERS/${ZK_SERVERS}/" /apache-drill/conf/drill-override.conf

sed -i -e "s/AWS_ACCESS_KEY_ID/${AWS_ACCESS_KEY_ID}/" /apache-drill/conf/core-site.xml
sed -i -e "s/AWS_SECRET_ACCESS_KEY/${AWS_SECRET_ACCESS_KEY}/" /apache-drill/conf/core-site.xml