# Mesos Docker Containers

## Overview
Set of Mesos-related docker containers based on slightly changed Mesosphere images. 

All images use Ubuntu 14.04 by default, all Mesos Slave images and derivatives have OpenJDK 7 and Docker installed.
 
## Running Mesos cluster locally

###Environment setup
It's possible to create a full Mesos environment on the local machine using docker-compose. 

Depending on one's needs virtual machine memory could be adjusted to different value, but memory should be gte 4GB. Steps to create new 
docker-machine and launch docker images:  

      docker-machine create -d virtualbox --virtualbox-memory "8000" --virtualbox-cpu-count "4" mesos
      eval "$(docker-machine env mesos)"
      
      (!) Add address of `docker-machine ip workshop` to /etc/hosts with next hostnames: 
      <ip address> mesos-master mesos-slave zookeeper marathon chronos  

      docker-compose up
      
After this Mesos Master and Slave, Marathon and Chronos should be available:

* Mesos Master [http://mesos-master:5050](http://mesos-master:5050)
* Marathon [http://marathon:8080](http://marathon:8080)
* Chronos [http://chronos:4400](http://chronos:4400)
      
###Using multiple slaves
Multiple Mesos Slaves could be used in local setup, for this entries in `docker-compose.yml` should be duplicated with 
appropriate port remapping to avoid conflicts. Example:

      mesos-slave-1:
        image: datastrophic/mesos-slave:0.27.1
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
        image: datastrophic/mesos-slave:0.27.1
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
      
###Enabling Spark
To use Spark-enabled images, minor changes are needed to `mesos-slave` in docker-compose:

      mesos-slave:
        image: datastrophic/mesos-spark:0.27.1-1.6
        hostname: "mesos-slave"
        privileged: true
        environment:
          - MESOS_HOSTNAME=mesos-slave
          - MESOS_PORT=5151
          - MESOS_MASTER=zk://zookeeper:2181/mesos
          - MESOS_LOG_DIR=/tmp/mesos
          - SPARK_PUBLIC_DNS=mesos-slave
        links:
          - zookeeper
          - mesos-master
        ports:
          - "5151:5151"
          - "4040:4040"
        volumes:
          - /sys/fs/cgroup:/sys/fs/cgroup
          - /var/run/docker.sock:/var/run/docker.sock
          
## Where to go from here

* [TBD] Mesos Workshop usage examples and sample framework implementation
* [TBD] Article describing Mesos architecture, core concepts and internals