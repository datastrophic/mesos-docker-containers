# Mesos Docker Containers

## Overview
Set of Mesos-related docker containers inspired by Mesosphere images. 

All images use Ubuntu 16.04 by default, all Mesos Slave images and derivatives have Oracle Java 8 and Docker installed.
 
## Running Mesos cluster locally

###Environment setup
It's possible to create a full Mesos environment on the local machine using docker-compose. 

####Docker-machine
Depending on one's needs virtual machine memory could be adjusted to different value, but memory should be gte 4GB. Steps to create new 
docker-machine and launch docker images:  

      docker-machine create -d virtualbox --virtualbox-memory "8000" --virtualbox-cpu-count "4" mesos
      eval "$(docker-machine env mesos)"
      
      (!) Add address of `docker-machine ip mesos` to /etc/hosts with next hostnames: 
      <ip address> 192.168.99.100 mesos-master mesos-slave zookeeper marathon chronos  

      docker-compose up
      
After this Mesos Master and Slave, Marathon and Chronos should be available:

* Mesos Master [http://mesos-master:5050](http://mesos-master:5050)
* Marathon [http://marathon:8080](http://marathon:8080)
* Chronos [http://chronos:4400](http://chronos:4400)

####Docker for mac
Docker for Mac doesn't need above steps, but the configured memory should be tweaked to account for running given containers.
      
###Using multiple slaves locally
Multiple Mesos Slaves could be used in local setup, for this entries in `docker-compose.yml` should be duplicated with 
appropriate port remapping to avoid conflicts. Example:

      mesos-slave-1:
        image: datastrophic/mesos-slave:1.1.0
        hostname: "mesos-slave-1"
        privileged: true
        environment:
          - MESOS_HOSTNAME=mesos-slave-1
          - MESOS_PORT=5151
          - MESOS_MASTER=zk://zookeeper:2181/mesos
        links:
          - zookeeper
          - mesos-master
        ports:
          - "5151:5151"
        volumes:
          - /sys/fs/cgroup:/sys/fs/cgroup
          - /var/run/docker.sock:/var/run/docker.sock
          
      mesos-slave-2:
        image: datastrophic/mesos-slave:1.1.0
        hostname: "mesos-slave-2"
        privileged: true
        environment:
          - MESOS_HOSTNAME=mesos-slave-2
          - MESOS_PORT=5252
          - MESOS_MASTER=zk://zookeeper:2181/mesos
        links:
          - zookeeper
          - mesos-master
        ports:
          - "5252:5252"
        volumes:
          - /sys/fs/cgroup:/sys/fs/cgroup
          - /var/run/docker.sock:/var/run/docker.sock      
      
###Running Chronos via Marathon in local environment
Instead of running Chronos as a separate Docker process it could be launched and managed with Marathon which will allow 
to scale instance number and manage configuration with ease. To launch Chronos Marathon's REST API should be used. Because of 
local environment specifics hostname resolution suffers when running docker-in-docker, so ip address in `CHRONOS_MASTER` 
and `CHRONOS_ZK_HOSTS` should point to `docker-machine ip mesos`.
       
       curl -XPOST 'http://marathon:8080/v2/apps' -H 'Content-Type: application/json' -d '{
         "id": "chronos",
         "container": {
           "type": "DOCKER",
           "docker": {
             "network": "BRIDGE",
               "image": "datastrophic/chronos:mesos-1.1.0-chronos-3.0.1",
               "parameters": [
                    { "key": "env", "value": "CHRONOS_HTTP_PORT=4400" },
                    { "key": "env", "value": "CHRONOS_MASTER=zk://'"$(docker-machine ip mesos)"':2181/mesos" },
                    { "key": "env", "value": "CHRONOS_ZK_HOSTS='"$(docker-machine ip mesos)"':2181"}
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

###Using Spark image

There are some problems with running Spark docker image from within a dockerized Mesos, to run spark-shell on a physical cluster the next command will 
be sufficient:
    
    docker run -ti --privileged datastrophic/mesos-spark spark-shell --master mesos://<mesos-master>:5050
          
## Where to go from here

* [TBD] Mesos Workshop usage examples and sample framework implementation
* [TBD] Article describing Mesos architecture, core concepts and internals