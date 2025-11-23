1. Task 1

- sudo useradd -m -s /bin/bash ivan
- sudo passwd ivan
- su -
- cd /home/ivan
- mkdir .certs && cd .certs
- openssl genrsa -out ivan.key 2048
- openssl req -new -key ivan.key -out ivan.csr -subj "/CN=ivan/O=gurus"
- openssl x509 -req -in ivan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out ivan.crt -days 365
- kubectl config set-credentials ivan --client-certificate=/home/ivan/.certs/ivan.crt --client-key=/home/ivan/.certs/ivan.key
- kubectl config set-context ivan-context --cluster=kubernetes --user=ivan
- mkdir /home/ivan/.kube
- cp ~/.kube/config /home/ivan/.kube/config
- vi /home/ivan/.kube/config

INSERT everything from context bellow:

contexts:

- context:
  cluster: kubernetes
  user: ivan
  name: ivan-context
  current-context: ivan-context
  kind: Config
  preferences: {}
  users:
- name: ivan
  user:
  client-certificate: /home/ivan/.certs/ivan.crt
  client-key: /home/ivan/.certs/ivan.key

- chown -R ivan: /home/ivan/

NOTE: REPEAT THE SAME STEPS FOR MARIANA USER !!!

2. Task 2

- kubectl create namespace projectx

3. Task 3

- Create an empty manifest file with: touch projectx-limitrange.yaml
- Populate it: vi projectx-limitrange.yaml
- kubectl apply -f projectx-limitrange.yaml

4. Task 4

- touch projectx-quota.yaml
- vi projectx-quota.yaml
- kubectl apply -f projectx-quota.yaml

5. Task 5

- touch devguru-role.yaml
- vi devguru-role.yaml
- kubectl apply -f devguru-role.yaml
- touch devguru-rolebinding.yaml
- vi devguru-rolebinding.yaml
- kubectl apply -f devguru-rolebinding.yaml

6. Task 6

- kubectl config use-context ivan-context
- navigate to the vagrant folder and use manifest files for producer-consumer application, so we don't have to create them from scratch. Note: We also modified them to match our setup
- create the curl-client.yaml manifest file in the vagrant folder so we can have all files in one place.
- kubectl apply -f producer-deployment.yml
- kubectl apply -f producer-svc.yml
- kubectl apply -f consumer-deployment.yml
- kubectl apply -f consumer-svc.yml
- kubectl apply -f curl-client.yaml
- kubectl get all -n projectx (optional) - we use it to verify the above step are applied correctly

TEST: (optional)

- kubectl exec -it curl-client -n projectx -- sh
- curl http://producer:5000
- curl http://consumer:5000

7. Task 7

- create the manifest files for network policies. We will do it again in vagrant folder for more consistency
  Apply the policies:

- kubectl apply -f producer-netpol.yaml
- kubectl apply -f consumer-netpol.yaml
- final tests (optional) - see image "Final tests"
