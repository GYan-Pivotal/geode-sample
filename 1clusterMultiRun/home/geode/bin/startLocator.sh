#!/bin/sh
NAME=`hostname`
gfsh start locator --port=30001 --dir=/home/geode/locator --name=locator_${NAME} --J=-Dgemfire.jmx-manager-port=20001 --J=-Xms2g --J=-Xmx2g --J=-Dgemfire.enable-cluster-configuration=true --J=-Dgemfire.use-cluster-configuration=true --include-system-classpath --properties-file=/home/geode/config/locator.properties &
