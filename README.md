# Mesos Docker Containers

## Overview
Set of Mesos-related docker containers built to address the latest updates of Mesos frameworks. Base Mesos images are used to install 
Chronos, Spark and Kafka binaries on top of them and run framework containers on bare metal Mesos installations. For demonstration purposes
 there's a docker-compose file provided to run cluster locally, however, limitations exist for local setup.

All images use Ubuntu 16.04 by default, framework images derive from Mesos base with Oracle Java 8 installed, Mesos agent images 
derive from Mesos base with Docker installed.

## Running Spark on Mesos
From any of Mesos agent nodes with Docker installed:

spark-shell:

      docker run -ti --net=host datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0 \
      spark-shell --master mesos://master.mesos:5050 --conf spark.mesos.executor.docker.image=datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0

spark-submit:

      docker run -ti --net=host datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0 \
      spark-submit --master mesos://master.mesos:5050 --conf spark.mesos.executor.docker.image=datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0 \
      --class org.apache.spark.examples.SparkPi /spark/examples/jars/spark-examples_2.11-2.1.0.jar 250

Submitting Spark job to Chronos to be executed on a regular manner:

      curl -L -H 'Content-Type: application/json' -X POST http://chronos.marathon.mesos:4400/v1/scheduler/iso8601 -d '{
        "schedule": "R/2017-02-14T12:00:00.000Z/PT3M",
        "name": "scheduled-spark-submit",
        "container": {
          "type": "DOCKER",
          "image": "datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0",
          "network": "HOST"
        },
        "cpus": "1",
        "mem": "2048",
        "fetch": [],
        "command": "spark-submit --master mesos://master.mesos:5050 --conf spark.mesos.executor.docker.image=datastrophic/mesos-spark:mesos-1.1.0-spark-2.1.0 --class org.apache.spark.examples.SparkPi /spark/examples/jars/spark-examples_2.11-2.1.0.jar 250"
        }'

## Running Chronos on Mesos
From any of Mesos agent nodes with Docker installed:

      docker run -ti \
      --net=host -p 4400:4400 \
      -e CHRONOS_HTTP_PORT=4400 \
      -e CHRONOS_MASTER=zk://<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181/mesos \
      -e CHRONOS_ZK_HOSTS=<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181 \
      datastrophic/chronos:mesos-1.1.0-chronos-3.0.1

Submitting to Marathon (port should be adjusted to be in resource offers port range):

      curl -XPOST 'http://marathon.mesos:8090/v2/apps' -H 'Content-Type: application/json' -d '{
         "id": "chronos",
         "container": {
           "type": "DOCKER",
           "docker": {
             "network": "HOST",
             "image": "datastrophic/chronos:mesos-1.1.0-chronos-3.0.1"
           }
         },
         "env": {
           "CHRONOS_HTTP_PORT":"4400",
           "CHRONOS_MASTER":"zk://<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181/mesos",
           "CHRONOS_ZK_HOSTS":"<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181"
         },
         "ports": [4400],
         "cpus": 1,
         "mem": 2048,
         "instances": 1,
         "constraints": [["hostname", "UNIQUE"]]
       }'
       
## Running Zeppelin on Mesos
From any of Mesos agent nodes with Docker installed (assuming S3 access is needed for a job):

      docker run -ti \
      --net=host -p 4400:4400 \
      -e CHRONOS_HTTP_PORT=4400 \
      -e CHRONOS_MASTER=zk://<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181/mesos \
      -e CHRONOS_ZK_HOSTS=<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181 \
      datastrophic/chronos:mesos-1.1.0-chronos-3.0.1

Submitting to Marathon (port should be adjusted to be in resource offers port range):

      curl -XPOST 'http://marathon.mesos:8090/v2/apps' -H 'Content-Type: application/json' -d '{
         "id": "chronos",
         "container": {
           "type": "DOCKER",
           "docker": {
             "network": "HOST",
             "image": "datastrophic/chronos:mesos-1.1.0-chronos-3.0.1"
           }
         },
         "env": {
           "CHRONOS_HTTP_PORT":"4400",
           "CHRONOS_MASTER":"zk://<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181/mesos",
           "CHRONOS_ZK_HOSTS":"<zookeeper_1>:2181,<zookeeper_2>:2181,<zookeeper_3>:2181"
         },
         "ports": [4400],
         "cpus": 1,
         "mem": 2048,
         "instances": 1,
         "constraints": [["hostname", "UNIQUE"]]
       }'

## Running Mesos locally
This setup is more for development and educational purposes and hits its limits when it comes to running docker containers via Marathon.

###docker-compose.yaml reference
```
version: '3'
services:

  zookeeper:
    image: mesoscloud/zookeeper:3.4.6-ubuntu-14.04
    hostname: "zookeeper"
    container_name: zookeeper
    ports:
      - "2181:2181"
      - "2888:2888"
      - "3888:3888"

  mesos-master:
    image: datastrophic/mesos-master:1.1.0
    hostname: "mesos-master"
    container_name: master
    privileged: true
    environment:
      - MESOS_HOSTNAME=mesos-master
      - MESOS_CLUSTER=SMACK
      - MESOS_QUORUM=1
      - MESOS_ZK=zk://zookeeper:2181/mesos
      - MESOS_LOG_DIR=/tmp/mesos/logs
    links:
      - zookeeper
    ports:
      - "5050:5050"

  mesos-slave:
    image: datastrophic/mesos-slave:1.1.0
    hostname: "mesos-slave"
    container_name: slave
    privileged: true
    environment:
      - MESOS_HOSTNAME=mesos-slave
      - MESOS_PORT=5151
      - MESOS_MASTER=zk://zookeeper:2181/mesos
    links:
      - zookeeper
      - mesos-master
    ports:
      - "5151:5151"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  marathon:
    image: datastrophic/marathon:1.3.6
    hostname: "marathon"
    container_name: marathon
    environment:
      - MARATHON_HOSTNAME=marathon
      - MARATHON_MASTER=zk://zookeeper:2181/mesos
      - MARATHON_ZK=zk://zookeeper:2181/marathon
    links:
      - zookeeper
      - mesos-master
    ports:
      - "8080:8080"

  chronos:
    image: datastrophic/chronos:mesos-1.1.0-chronos-3.0.1
    hostname: "chronos"
    container_name: chronos
    environment:
      - CHRONOS_HTTP_PORT=4400
      - CHRONOS_MASTER=zk://zookeeper:2181/mesos
      - CHRONOS_ZK_HOSTS=zookeeper:2181
    links:
      - zookeeper
      - mesos-master
    ports:
      - "4400:4400"
```

###Environment
Current steps are tested with Docker for Mac:

      Docker version         1.13.1
      docker-compose version 1.11.1
      docker-py version      2.0.2

Containers configuration is located in [docker-compose.yml](docker-compose.yml) in the root folder of this repo.

To rebuild images please refer to [bin/build-all.sh](bin/build-all.sh) helper script

###Running Mesos cluster
To spin up a cluster with zookeeper, master, agent, marathon and chronos one instance each:
      
      docker-compose -p mesos up -d --force-recreate
      
      (!) It might be useful to add alias for containers hostnames to /etc/hosts 
      127.0.0.1 mesos-master mesos-slave zookeeper marathon chronos 
      
It is important to specify `-p mesos` flag (docker-compose project name) to ease the reference to default network created automatically.

After this Mesos Master and Slave, Marathon and Chronos should be available:

* Mesos Master [http://mesos-master:5050](http://mesos-master:5050)
* Marathon [http://marathon:8080](http://marathon:8080)
* Chronos [http://chronos:4400](http://chronos:4400)

Remove the containers with:
      
      docker-compose -p mesos down && docker-compose -p mesos rm -f
            
###Using multiple agents locally
Multiple Mesos agents could be used in local setup, for this entries in `docker-compose.yml` should be duplicated with 
appropriate port remapping to avoid conflicts. Check out [docker-compose-bare-mesos.yml](docker-compose-bare-mesos.yml) 
for the reference.

###Docker in Docker
Socket binding allows to run docker containers from within Mesos agents which have Docker installed:
      
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        
Here is an example of running dockerized Chronos inside Mesos Docker container:

- ensure current docker-compose stack is not running `docker-compose -p mesos top` and stop it if it is `docker-compose -p mesos down && docker-compose -p mesos rm -f`
- run docker-compose with dedicated compose file containing zookeper, Mesos master and two agents with `docker-compose -f docker-compose-bare-mesos.yml -p mesos up -d --force-recreate`
- attach to one of the running agents `docker exec -ti slave-1 /bin/bash`
- run 


         docker run -ti \
         --net=mesos_default -p 4400:4400 \
         -e CHRONOS_HTTP_PORT=4400 \
         -e CHRONOS_MASTER=zk://zookeeper:2181/mesos \
         -e CHRONOS_ZK_HOSTS=zookeeper:2181 \
         datastrophic/chronos:mesos-1.1.0-chronos-3.0.1

- now Chronos UI should be available at [http://chronos:4400](http://chronos:4400) or [http://localhost:4400](http://localhost:4400) if you haven't modified `/etc/hosts`
- shutdown the stack `docker-compose -p mesos -f docker-compose-bare-mesos.yml down && docker-compose -p mesos -f docker-compose-bare-mesos.yml rm -f`


The approach used here is in specifying network `mesos_default` from parent containers so all the top-level containers could be reached and 
their hostnames resolved. This network is created by default when docker-compose is executed for first time.

###Limitations of local setup
In production Mesos cluster the best practice is to run Chronos via Marathon to provide high availability guarantees. 
This could be done by posting appropriate Marathon configuration for Chronos application:
  
      curl -XPOST 'http://marathon:8080/v2/apps' -H 'Content-Type: application/json' -d '{
        "id": "chronos",
        "container": {
          "type": "DOCKER",
          "docker": {
              "network": "BRIDGE",
              "privileged":true,
              "image": "datastrophic/chronos:mesos-1.1.0-chronos-3.0.1",
              "parameters": [
                   { "key": "env", "value": "CHRONOS_HTTP_PORT=4400" },
                   { "key": "env", "value": "CHRONOS_MASTER=zk://zookeeper:2181/mesos" },
                   { "key": "env", "value": "CHRONOS_ZK_HOSTS=zookeeper:2181"}
              ],
              "portMappings": [
                { "containerPort": 4400 }
              ]
          }
        },
        "cpus": 1,
        "mem": 512,
        "instances": 1
      }'
  
However, this configuration will not work locally because Marathon doesn't support custom network types and with any other network type  
Chronos container WILL NOT be able to reach zookeeper and bind Chronos to routable address. 

Same limitations apply for Spark and Kafka Docker containers as well if they're executed from within Docker.
          
## Where to go from here

* [Mesos Workshop: usage examples and sample framework implementation](https://github.com/datastrophic/mesos-workshop)
* [Resource Allocation in Mesos: Dominant Resource Fairness blog post](http://datastrophic.io/resource-allocation-in-mesos-dominant-resource-fairness-explained/)