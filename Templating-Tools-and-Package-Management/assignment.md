Try to solve the following set of tasks:
1.	Using the files in task1 folder create a template using the sed-based approach. Parametrize the number of replicas and the service port
2.	Using the files in task2 folder create a template using kustomize with two variants – test and production with difference in the service port and number of replicas
3.	Create a Helm chart that spins a NGINX-based deployment with 3 replicas by default. It must mount a default index.html (with a text and a picture) page from a ConfigMap. The web server should be exposed via NodePort service on port 31000 by default. At least the text of the default page, number of replicas, and service port should be parametrized
