## Scenario 2

- Change the names of the volumeMounts in init and 1st sidecar containers from html to data, so they matches the name of the volume
- change the volumeMounts path of the init container from /usr/share/nginx/html to /data
- change the command of the init container from ["/bin/bash", "-c"] to ["/bin/sh", "-c"]
- fix the args in init container so that ";)" get inside the copied message i.e inside ''
- fix the selector name in the Service - change it from readiness-cmd to readiness-http so it match the app name

## #Scenario 3

- increase the failureThreshold from 3 to bigger number (for example 20). The calculated value must be bigger than 25 (20 * 5 is bigger than 5 + 20)
  *Node: The healthy.html file is created after 20 seconds by the sidecar + 5 sec initial delay!
- change the liveness probe http path from /check/healthy.html to /healthy.html
- change the exec command from /check/healthy.html to the correct path /usr/share/nginx/html/healthy.html
- fix the port in the Service from 8080 to 80
- fix the name of the selector from startup-nixed to startup-mixed

## Scenario 4

#ON CP NODE -> Node1 ONLY

- Install NFS server:
  ssh vagrant@node1 -- sudo apt-get update && sudo apt-get install -y nfs-kernel-server nfs-common
- Create the directories:
  ssh vagrant@node1 -- sudo mkdir -m 777 -p /data/nfs/k8spv{a,b,c}
- Configure exports
  ssh vagrant@node1 -- 'for i in {a..c}; do echo "/data/nfs/k8spv$i *(rw)" | sudo tee -a /etc/exports; done'
- Apply exports
  ssh vagrant@node1 -- sudo exportfs -rav

#ON ALL NODES

- echo '192.168.99.101 nfs-server' | sudo tee -a /etc/hosts
- sudo apt-get update && sudo apt-get install -y nfs-common

#FIXES for the manifests

- change the headless service app selector name from factc to facts
- change the type of the public (NodePort) service from ClusterIP to NodePort
- change the app selector name for the public (NodePort) service from fact to facts
- change the
- change the accessModes for PV "b" from ReadOnly to ReadWriteOnce
- change the capacity storage value for PV "a" and "b" to be equal to 1Gi
- fix the typo in PV "c" path from /bata/nfs/k8spvc to /data/nfs/k8spvc
- reduce the replicas number from 4 to 3 in SS because we have only 3 PV -> a,b and c
- apply each file starting from PV -> Headless server, SS and SVC-NP:

- kubectl apply -f pvss.yaml
- kubectl apply -f svcss.yaml
- kubectl apply -f ss.yaml
- kubectl apply -f svcssnp.yaml
