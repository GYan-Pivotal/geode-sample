#Geode Env configuration and setup

[toc]


**login as root**

## OS Env
### sync time on all servers
   specify NTP server

### User and Groups
add 'geode' group and 'geode' user

```Shell
$ sudo groupadd geode
$ sudo useradd -g geode geode
$ sudo passwd geode
```


### set swappiness
vi /etc/sysctl.conf

```Shell
vm.swappiness=0
vm.overcommit_memory=2
vm.overcommit_ratio=100
net.ipv4.tcp_rmem=10240 131072 33554432
net.ipv4.tcp_wmem=10240 131072 33554432
```



```Shell
sysctl -p
```


### set file-descriptor and process for current user
 vi  /etc/security/limits.conf
 
```Shell
* soft nofile 1048576
* hard nofile 1048576
* soft nproc 1048576
* hard nproc 1048576
```
 vi  /etc/security/limits.d/90-nproc.conf
 
```Shell
* soft nproc 1048576
```
### turn-off iptables

```Shell
service    iptables  stop
chkconfig  iptables  off
```

### set Hosts
modify /etc/hosts，to add all ip of all members, include locator and CacheServer

### update hostname
#### RedHat
vi /etc/sysconfig/network

```Shell
NETWORKING=yes
HOSTNAME=RH-64-GEODE-01
```

#### SUSE
vi /etc/HOSTNAME
```Shell
NETWORKING=yes
HOSTNAME=RH-64-GEODE-01
```

## installation
### install JDK
please install JDK version specified by Apache Geode documentation

### install Geode
considering Geode version match
considering OS version match

can refer to :
https://geode.apache.org/docs/guide/19/getting_started/system_requirements/host_machine.html



## Restart

```Shell
 shutdown -r now
```
 

**login as geode**
## set env parameter
vi config file, please choose one of following to do configuration.

```
~/.bash_rc;
~/.bash_profile;
/etc/profile;
```


```Shell

JAVA_HOME=/usr/java/jdk1.8.0_121
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME PATH
 
GEODE=/opt/apache-geode/geode_190
GF_JAVA=$JAVA_HOME/bin/java
PATH=$PATH:$GEODE/bin:/home/geode/bin
CLASSPATH=$GEODE/lib/*
CLASSPATH=$CLASSPATH:/home/geode/lib/*
CLASSPATH=$CLASSPATH:$JAVA_HOME/lib/*
export GEODE GF_JAVA PATH CLASSPATH
 
alias cdg="cd /home/geode"
alias ll="ls -trl"
```

## deployment
### create folders for running
/home/geode/

refer to the following folder structure：

```
/home/geode/
├── backup       - for backup
├── bin          - for shell
├── config       - for config
├── data         - for data backup
├── deploy       - for hot deploy function
├── lib          - for lib
├── locator      - running folder for locator
└── server       - running folder for cacheserver

```

### Geode cluster config
/home/geode/config/geode.properties

```Shell
bind-address=182.119.94.178
mcast-port=0
locators=[locator1 ip][30001],[locator2 ip][30001]

cache-xml-file=/home/geode/config/cache-server.xml
conserve-sockets=false
enable-network-partition-detection=true

log-level=config
log-disk-space-limit=10000
log-file-size-limit=50


statistic-sampling-enabled=true
statistic-sample-rate=2000
statistic-archive-file=statics.gfs
archive-file-size-limit=100
archive-disk-space-limit=1000

enable-cluster-configuration=true
use-cluster-configuration=true
```

/home/geode/config/locator.properties

```Shell
bind-address=[host ip]
mcast-port=0
log-file=/home/geode/locator/locator.log
locators=[locator1 ip][30001],[locator2 ip][30001]
enable-network-partition-detection=true
conserve-sockets=false

log-level=config
log-disk-space-limit=10000
log-file-size-limit=50

statistic-sampling-enabled=true
statistic-sample-rate=2000
statistic-archive-file=statics.gfs
archive-file-size-limit=100
archive-disk-space-limit=1000

enable-cluster-configuration=true
use-cluster-configuration=true
```
 
### config Geode shell script
#### scprit to run locator
vi /home/geode/bin/startlc.sh

```Shell
#!/bin/sh
NAME=`hostname`
gfsh start locator --port=30001 --dir=/home/geode/locator --name=locator_${NAME} --J=-Dgemfire.jmx-manager-port=20001 --J=-Xms2g --J=-Xmx2g --J=-Dgemfire.enable-cluster-configuration=true --J=-Dgemfire.use-cluster-configuration=true --include-system-classpath --properties-file=/home/geode/config/locator.properties &
``` 
#### script to run cacheserver
vi /home/geode/bin/startServer.sh

```Shell
#!/bin/sh
HOSTNAME=`hostname`
DATE=`date +%Y-%m-%d-%H-%M`
gfsh start server --name=cache_${HOSTNAME} --locators=[locator1 ip][30001],[locator2 ip][30001] --server-port=60001 --include-system-classpath --properties-file=/home/geode/config/geode.properties --dir=/home/geode/server --J=-Xms31g --J=-Xmx31g --J=-Xmn2g --J=-XX:MaxPermSize=256m --J=-XX:PermSize=256m --J=-Xss256k --J=-XX:+UseParNewGC --J=-XX:+UseConcMarkSweepGC --J=-XX:CMSInitiatingOccupancyFraction=70 --J=-XX:+UseCMSInitiatingOccupancyOnly  --J=-XX:+UnlockDiagnosticVMOptions --J=-XX:ParGCCardsPerStrideChunk=32768 --J=-XX:+CMSParallelRemarkEnabled --J=-XX:+ScavengeBeforeFullGC --J=-XX:+CMSScavengeBeforeRemark  --J=-XX:+PrintGCDetails  --J=-XX:+PrintGCDateStamps --J=-XX:+PrintHeapAtGC --J=-XX:+PrintClassHistogram  --J=-XX:+PrintGCApplicationStoppedTime --J=-Xloggc:/home/geode/log/gc_cache_${HOSTNAME}_${DATE}.log --J=-Dgemfire.enable-cluster-configuration=true --J=-Dgemfire.use-cluster-configuration=true &
```

open remote Debug

```Shell
--J=\"-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=50101\"
```

## Cluster Operation
### startup
run locator
>in 1 cluster, there are 2 locators at least. 

>In the latest version, it is also recommanded to run 3 locators per cluster.

run cacheserver
>cluster with Partition Region， 3 Cacheserver at least

>cluster without Partition Region， 2 CacheServer at least

### stop
in Geode, recommanded to shutdown server and clusters GRACEFULLY.

1. first , try to run 'gfsh stop' or 'shutdown' in GFSH (GRACEFULLY way)

1. then try 'kill -2'

1. then try 'kill -9'

## Reference
### header of Cache.xml  for Geode
Server side

```XML
<?xml version="1.0" encoding="UTF-8"?>
<cache
    xmlns="http://geode.apache.org/schema/cache"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://geode.apache.org/schema/cache http://geode.apache.org/schema/cache/cache-1.0.xsd"
    version="1.0">
...
</cache>
```

client side

```XML
<?xml version="1.0" encoding="UTF-8"?>
<client-cache
    xmlns="http://geode.apache.org/schema/cache"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://geode.apache.org/schema/cache http://geode.apache.org/schema/cache/cache-1.0.xsd"
    version="1.0">
...
</client-cache>
```
### hot deploy env considering
1. set deploy-working-dir

1. do not put deploy-working-dir into classpath

1. do not put funtion jar file to classpath

### Log4j2
add following to the script to run cacheserver

```
-Dlog4j.configurationFile=<location-of-your-file>
```