# geode-sample
some sample project and best practice to run Apache Geode as a cluster
[generalSetup.md](generalSetup.md) is general for all the setup, the other folders is some sample for scenarios.

### Project Break Down

```
.
├── generalSetup.md      - a handbook to setup an env for geode
├── 1cluster             - setup a cluster for 2*3
├── 1clusterMultiRun     - setup a cluster, to run multi process on 1 host
└── 2clustersForWan      - setup 2 clusters for wan-gateway

```
### General Recommandations
for HA and high performance, there are some tips for GEODE:

1. for 1 cluster, start at least 2-3 locators

1. put locators on diff host, that will increase HA to the cluster.

1. for storage,  avoid to use NAS,  prefer to use SAN or DAS.  DAS (Direct Attached Storage), NAS (Network Attached Storage) and SAN (Storage Area Networks).

1. assign same memory to all the cacheserver

1. assign all the members of a cluster in one switch, to avoid network issues

1. assign 2G or 4G to locator. please consider to add more memory to locator , when you find some gc issues.

2. avoid to put locator and cacheserver on 1 host, that will cause this host to be a different one than the other hosts 

1. assign diffrent port for locators, if you want to run more than 1 locator on 1 host

1. add nohup to the shell, to avoid shutdown processes of locators and cacheservers when you quit the terminal.

2. assign Xms and Xmx to be same , to avoid dynamic memory asignment when JVM is running, that will cause performance down.

3. generally, set the Xmn to be 2G-4G.And you can adjust this

4. all the old (maybe for Java 1.1 and 1.2, or 1.5) JVM tips may not work

5. adjust JVM runtime parameter, after reviewed GC logs

6. For GC logs,  to see and analyze how the memory is consumed, the following tool can help you:
   - GCViewer: https://github.com/chewiebug/GCViewer
   - GCeasy: https://gceasy.io/

### Recommandations for VM
if you plan to run Geode in Virtual Machine env, please read the following link first:
https://geode.apache.org/docs/guide/19/managing/monitor_tune/performance_on_vsphere.html

**Especially, please take care about vMotion settings.** Not to set it to be true by default.

**keep the ratio of vm:jvm:"geode process" to be 1:1:1** , that will simplify the running model of Geode and will reduce racing issues of jvm and "geode process".

### refer
- https://github.com/charliemblack/geode-geospatial-index/blob/master/README.md#how-to-scale-the-grid

- https://github.com/charliemblack/geode-geospatial-index/blob/master/README.md#common-jvm-settings-for-production