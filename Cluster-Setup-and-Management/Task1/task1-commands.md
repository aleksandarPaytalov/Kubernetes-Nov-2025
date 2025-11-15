minikube start --driver=hyperv --nodes 2 -p m2-homework
kubectl label node m2-homework-m02 node-role.kubernetes.io/worker=worker (не е задължителна)
kubectl create deployment oracle --image=shekeriev/k8s-oracle
kubectl expose deployment oracle --type=NodePort --port=5000
minikube service oracle -p m2-homework
