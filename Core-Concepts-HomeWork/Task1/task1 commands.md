#Commands#
1a: 
- kubectl create namespace homework
1b: 
- kubectl run homework-1 -n homework --image=shekeriev/k8s-oracle --labels="app=hw,tier=gold"
1c:
- kubectl label pod homework-1 -n homework tier-
1d:
- kubectl run homework-2 -n homework --image=shekeriev/k8s-oracle
1e:
- kubectl label pod homework-2 -n homework app=hw run-
1f:
- kubectl annotate pods homework-1 homework-2 -n homework purpose=homework
1g:
- kubectl create service nodeport homework-svc -n homework --tcp=5000:5000 --node-port=32000
- kubectl set selector service homework-svc -n homework app=hw