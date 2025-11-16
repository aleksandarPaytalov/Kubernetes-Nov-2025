1. setup the folder structior and following files:

- Vagrantfile
- common.sh
- master.sh
- worker.sh

2. vagrant validate

3. vagrant up --provider=hyperv

4. wait for the installation to complete (around 10-15 min) and test with following commands if everyting is working

- connect to the Control plane node from the host machine via ssh setion with "ssh vagrant@192.168.0.10" (You IP may varie - be different)
- kubectl get nodes & kubectl get pods -A

5. Deploy Nginx to test it further. Use commands:

- kubectl create deployment nginx --image=nginx --replicas=3
- kubectl get deployments
- kubectl get pods

6. Expose Nginx as a Service

- kubectl expose deployment nginx --port=80 --type=NodePort --name=nginx-service
- kubectl get svc nginx-service -o wide
- kubectl get pods -o wide

7. Remove

- vagrant destroy -f
