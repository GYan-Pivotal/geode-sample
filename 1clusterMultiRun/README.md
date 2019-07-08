## for 1 cluster, multi servers run on 1 box
in this cluster,  you can run multi server in 1 VM/physical machine.

### General Recommandations
  1.  make sure , your resouces(CPU/MEM/Disk) are enough for all the servers.
  2.  for scale out,  just add more VM/physical machine.  It is not recommmanded to scale up , because need to add more benchmark works and reliability validation test as preparation.
  3.  disk and network are general source of problem.
  4.  refer to [General Recomandations](https://github.com/GYan-Pivotal/geode-sample#general-recommandations)

