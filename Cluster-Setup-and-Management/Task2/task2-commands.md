New-Item -Path kind-config.yml -ItemType File ---> създаваме yml файл и го попълваме чрез някой редактор (nodepad++, VisualStudio Code ..)

kind create cluster --name m2-homework-task2 --config kind-config.yml

kubectl cluster-info --context kind-m2-homework-task2 ---> проверка на клъстъра (не е задължителна команда)

kubectl create deployment oracle --image=shekeriev/k8s-oracle

kubectl expose deployment oracle --type=NodePort --port=5000

kubectl port-forward service/oracle 5000:5000
