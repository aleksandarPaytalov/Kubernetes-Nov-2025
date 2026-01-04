Tasks checklist
Mars Cluster [18 pts]
•	(T101 / 3 pts) There is the animals namespace. There are two pairs of pod and service. You are expected to create an ingress resource (using the available ingress controller and class) that
o	Will be in the same namespace and named pets-ingress
o	Will serve the pets.lab host
o	Path /cat to be redirected to cat-svc service and /dog to the dog-svc
o	Store it in /files/mars/t101-out.yaml and be sure to deploy it
•	(T102 / 3 pts) Explore the tiger namespace. There is a pod that is not in running state, but it should be. Its manifest is /files/mars/t102-in.yaml. Your mission, should you accept it, is to
o	Correct the issue(s) and reflect this in a new manifest /files/mars/t102-out.yaml
o	Make sure that the pod is in running state and doesn’t restart periodically because of a probe
•	(T103 / 4 pts) Templating is a good and necessary technique. We have a simple manifest (/files/mars/t103-in.yaml) which we want to be able to easily deploy in production (blue) and in test (green). Using the kustomize application, you must prepare a set of folders and files in the /files/mars/t103 folder that allows 
o	Base (without any changes) deployment and deployment to both environments
o	The blue deployment should increase the replicas to 3, use the blue tag, and run on port 31103
o	The green deployment should use the green image tag and runs on port 32103
o	Make sure that blue and green are deployed (but not the base)
•	(T104 / 2 pts) Explore the cherry namespace. There is a deployment that is failing. Your mission is to 
o	Find the reason for this and write it down (type of the object:name of the object, for example limit:banana) in the /files/mars/t104-reason.txt file
o	Correct the situation by changing the offending parameter of the deployment to comply  
•	(T105 / 2 pts) Explore the pod manifest in /files/mars/t105-in.yaml file and
o	Create a new one (/files/mars/t105-out.yaml) that wraps the pod template in a CronJob named five-job
o	Set it to run every 5 minutes and deploy it
•	(T106 / 4 pts) There is the fortress namespace. It is empty. Your mission is to
o	Create a ServiceAccount named observer
o	Create a Role named looknotouch that allows only get on pods
o	Create a RoleBinding named looknotouch that binds the role to the service account
o	Modify the pod manifest /files/mars/t106-in.yaml to run the pod with the observer service account, store the new version in /files/mars/t106-out.yaml and deploy it
Jupiter Cluster [25 pts]
•	(T201 / 4 pts) There are three namespaces – apple, orange, and apricot. In all three, there is a pair of pod and service. There aren’t any restrictions. You should correct this:
o	Add a network policy that will limit the ingress access to the pods in the apple namespace to connections, coming only from pods in the orange namespace
•	(T202 / 5 pts) We all know that using Helm charts is both fun and easy. So, let’s spin up one chart
o	Use artifacthub.io and find the NGINX chart provided by Bitnami and add the repository
o	Then install the chart as exam-httpd release in the kiwi namespace (create it if not existing)
o	Make sure that using the chart’s parameters it is set to use a service of type NodePort and to listen for HTTP request on port 32202
o	Create a ConfigMap named exam-httpd-cm in the same namespace that contains an index.html file with the following text Helm+Kubernetes=Fun and attach it to the release
•	(T203 / 4 pts) There is a pod in the cucumber namespace that is consuming a secret in the same namespace. You are expected to:
o	Find the unencoded value of the secret and save it as /files/jupiter/t203-secret.txt
o	Then change the secret to Cucumbers are green
•	(T204 / 2 pts) Add a new label (exam) to both worker nodes (jupiter-2 and jupiter-3):
o	Set its value to slow for jupiter-2 
o	Set its value to fast for jupiter-3
•	(T205 / 1 pts) Explore the manifest /files/jupiter/t205-in.yaml
o	Modify it in such a way that if deployed, the workload to go on the node with label exam set to fast and save the new manifest as /files/jupiter/t205-out.yaml
o	Deploy it to the cluster
•	(T206 / 1 pts) Explore the manifest /files/jupiter/t206-in.yaml
o	Modify it in such a way that if deployed, the workload to go on the node named jupiter-2 and save the new manifest as /files/jupiter/t206-out.yaml
o	Deploy it to the cluster
•	(T207 / 4 pts) Explore the banana namespace. There should be a pair of pod and service. They are created out of the /files/jupiter/t207-in.yaml manifest. The problem is that the pod (banana-pod-1) is not in running state and the service (banana-svc) does not have any endpoints. Your mission is to:
o	Correct these issues and save the changes as /files/jupiter/t207-out.yaml manifest
o	Make sure that the deployed objects are in a good shape (they reflect the corrections)
o	Add a second pod, in the new manifest file, of the same type but change the image tag to green and name it banana-pod-2
o	Make sure that the new pod is present in the service endpoints list
•	(T208 / 4 pts) Explore the manifest /files/jupiter/t208-in.yaml and 
o	Extend it to also include
	A definition of a namespace named cherry
	and a definition of a service named cherry-svc of type NodePort and port set to 32208
	and save it as /files/jupiter/t208-out.yaml
o	Deploy the manifest
Venus Cluster [17 pts]
•	(T301 / 5 pts) Install the missing system components (kubeadm, kubelet, and kubectl) on the venus-2 node and make sure that their version is aligned with the version installed on the venus-1 node
•	(T302 / 3 pts) Join the venus-2 node to the Venus Cluster
•	(T303 / 2 pts) Deploy Antrea pod network plugin on the Venus Cluster
•	(T304 / 3 pts) Modify the configuration of the Venus Cluster in such a way to allow workload to be placed on the control plane node 
•	(T305 / 4 pts) Explore the manifest /files/venus/t305-in.yaml and 
o	Change it in such a way (save it under /files/venus/t305-out.yaml) that the described pod is deployed on every node of the cluster
o	Deploy the resulting manifest
