#Task 1:
a)
I. kubectl create configmap hwcm --from-literal=k8sver=v1.33.3 --from-literal=k8sos=debian13

II.  
cat > main.conf << EOF
name=homework
path=/tmp
certs=/secret
EOF

--------

cat > port.conf << EOF
8080
EOF

--------
Option1: kubectl edit cm hwcm

and add this in data section:
main.conf: |
  name=homework
  path=/tmp
  certs=/secret
port.conf: "8080"

Option2: kubectl create configmap hwcm --from-literal=k8sver=v1.33.3 --from-literal=k8sos=debian13 --from-file=main.conf --from-file=port.conf
but first you need to remove the cm if we have created it with the 1swt task: kubectl delete cm hwcm

b)
- openssl genrsa -out main.key 4096
- openssl req -new -x509 -key main.key -out main.crt -days 365 -subj /CN=www.hw.lab
- kubectl create secret generic hwsec --from-file=main.key --from-file=main.crt
- verify (optional) kubectl get secret hwsec -o yaml

c)
- kubectl apply -f pod-1c.yaml

note: first we need to navigate to the folder where out manifest file is created. in Out case: cd /vagrant/manifest-files/

#Task 2
- ssh vagrant@nfs-server -- sudo mkdir -m 777 -p /data/nfs/pv-be{1,2,3}
- ssh vagrant@nfs-server -- 'for i in {1..3}; do echo "/data/nfs/pv-be$i *(rw)" | sudo tee -a /etc/exports; done'
- ssh vagrant@nfs-server -- sudo exportfs -rav

- kubectl apply -f pv-be-1.yaml
- kubectl apply -f pv-be-2.yaml
- kubectl apply -f pv-be-3.yaml
- kubectl apply -f svc-be.yaml
- kubectl apply -f statefulset-be.yaml
- kubectl apply -f deployment-fe.yaml
- kubectl apply -f svc-fe.yaml

verificalition commands (optinal)
- kubectl get pods, svc
- kubectl get pvc -o wide
- kubectl get nodes -o wide
- http://192.168.99.101:30000