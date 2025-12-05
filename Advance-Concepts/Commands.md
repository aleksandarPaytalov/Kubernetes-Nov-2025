##Task 1
- kubectl apply -f /vagrant/manifests/init-container.yaml

##Task2
# SetUp the nginx-ingress controller 
- git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v5.2.1 cd kubernetes-ingress/deployments
- kubectl apply -f common/ns-and-sa.yaml
- kubectl apply -f rbac/rbac.yaml
- kubectl apply -f ../examples/shared-examples/default-server-secret/default-server-secret.yaml
- kubectl apply -f common/nginx-config.yaml
- kubectl apply -f common/ingress-class.yaml
- kubectl apply -f ../config/crd/bases/k8s.nginx.org_virtualservers.yaml
- kubectl apply -f ../config/crd/bases/k8s.nginx.org_virtualserverroutes.yaml
- kubectl apply -f ../config/crd/bases/k8s.nginx.org_transportservers.yaml
- kubectl apply -f ../config/crd/bases/k8s.nginx.org_policies.yaml
- kubectl apply -f ../config/crd/bases/k8s.nginx.org_globalconfigurations.yaml
- kubectl apply -f deployment/nginx-ingress.yaml
- kubectl create -f service/nodeport.yaml
#
*** Create a Self-Signed Certificate
# Create a directory for certificates
mkdir -p ~/k8s-certs
cd ~/k8s-certs

# Generate a private key
openssl genrsa -out demo.lab.key 2048

# Generate a certificate signing request (CSR)
openssl req -new -key demo.lab.key -out demo.lab.csr -subj "/CN=demo.lab/O=MyOrganization"

# Generate the self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in demo.lab.csr -signkey demo.lab.key -out demo.lab.crt

*** Create a Kubernetes Secret with the Certificate
- kubectl create secret tls demo-tls-secret --cert=demo.lab.crt --key=demo.lab.key -n default

*Verify that the secret was created (optional)
- kubectl get secrets -n default
- kubectl describe secret demo-tls-secret


- kubectl apply -f manifests/fanout-with-tls.yaml
* verify that recources have been created (optional)

- kubectl get pods
- kubectl get services
- kubectl get ingress
- kubectl describe ingress ingress-ctrl

- kubectl get svc -n nginx-ingress -o wide


- curl -k https://demo.lab:30990/service1

- curl -k https://demo.lab:30990/service2

- curl -k https://demo.lab:30990/



##Task3

- kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

# Create directory for certificates
mkdir -p ~/k8s-certs-contour
cd ~/k8s-certs-contour

# Generate private key
openssl genrsa -out demo.lab.key 2048

# Generate Certificate Signing Request (CSR)
openssl req -new -key demo.lab.key -out demo.lab.csr -subj "/CN=demo.lab/O=ContourLab/C=BG"

# Generate self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in demo.lab.csr -signkey demo.lab.key -out demo.lab.crt
  
# Create the secret in default namespace
kubectl create secret tls demo-tls-secret --cert=demo.lab.crt --key=demo.lab.key -n default

- kubectl apply -f manifests/contour-fanout-complete.yaml


(optional) 
- kubectl get pods
- kubectl get svc
- kubectl get httpproxy
- kubectl describe httpproxy fanout-proxy


- curl -k https://demo.lab:32707/service1
- curl -k https://demo.lab:32707/service2
- curl -k https://demo.lab:32707