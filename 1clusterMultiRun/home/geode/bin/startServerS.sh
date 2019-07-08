#!/bin/bash
HOSTNAME=`hostname`
DATE=`date +%Y-%m-%d-%H-%M`

if [ ! -n "$1" ]; then 
 	echo "ERROR: no node number. Example: startServerS.sh 1 7500m"
 	exit 1
fi
if [ ! -n "$2" ]; then 
 	echo "ERROR: no heap size. Example: startServerS.sh 1 7500m"
 	exit 1
fi
if [ -z "$ENV_HOME" ];then
 	PRG="$0"
 	PRGDIR=`dirname "$PRG"`
 	ENV_HOME=`cd "$PRGDIR"/.. ;pwd`
 	. "$ENV_HOME"/bin/setEnv.sh
fi
i=1
while [ $i -le $1 ] ; 
do
    echo "Start GemFire Server:"+$i
   
    gfsh start server --name=cache_${HOSTNAME}_s$i --locators=[locator1 ip][30001],[locator2 ip][30001] --server-port=60001 --include-system-classpath --properties-file=/home/geode/config/geode.properties --dir=/home/geode/server/s$i --J=-Xms$2 --J=-Xmx$2 --J=-Xmn2g --J=-XX:MaxPermSize=256m --J=-XX:PermSize=256m --J=-Xss256k --J=-XX:+UseParNewGC --J=-XX:+UseConcMarkSweepGC --J=-XX:CMSInitiatingOccupancyFraction=70 --J=-XX:+UseCMSInitiatingOccupancyOnly  --J=-XX:+UnlockDiagnosticVMOptions --J=-XX:ParGCCardsPerStrideChunk=32768 --J=-XX:+CMSParallelRemarkEnabled --J=-XX:+ScavengeBeforeFullGC --J=-XX:+CMSScavengeBeforeRemark  --J=-XX:+PrintGCDetails  --J=-XX:+PrintGCDateStamps --J=-XX:+PrintHeapAtGC --J=-XX:+PrintClassHistogram  --J=-XX:+PrintGCApplicationStoppedTime --J=-Xloggc:/home/geode/log/s$i/gc_cache_${HOSTNAME}_${DATE}.log --J=-Dgemfire.enable-cluster-configuration=true --J=-Dgemfire.use-cluster-configuration=true &
    i=$[$i+1]    
done