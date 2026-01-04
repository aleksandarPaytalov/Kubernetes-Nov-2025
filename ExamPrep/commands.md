#Establish an SSH connection to the main station (exam)

shh -p 10001 exam@192.168.1.241

#see the available clusters 
kubectl config get-contexts
#change the cluster with
kubectl config use-context {името на клъстъра към който искаме да направим връзка} 

#check available nodes. Here we can see also the version (in our case durring the prep is *1.33.3)
kubectl get nodes

### Task3 Steps ###
* connect to the node (vanus-2) that we will repair
* check if the author have installed the repository and waht version it is if he did 
- grep kubernetes /etc/apt/sources.list
- ls -al /etc/apt/sources.list.d/
- cat /etc/apt/sources.list.d/kubernetes.list   (проверяваме дали е регистрирано правилното репозитори)
- sudo apt-get update
- apt-cache madison kubelet
- apt-get install kubelet=1.33.3-1.1 kubeadm=1.33.3-1.1 kubectl=1.33.3-1.1
- sudo apt-mark hold kubelet kubeadm kubectl
- exit (
* проверяваме за token и дали той още е валиден - активен) за да може да присъединим нода към клъстъра
- ssh venus-1
- kubeadm token list

* По удобния вариант е да създадем направо нов с командата
- kubeadm token create --print-join-command

* Тази команда ще ни даде и join командата, която трябва да изпълним във ***venus-2**, за да я присъединим към клъстъра
- ssh venus-2
- kubeadm join [IP]:6443 --token [TOKEN] --discovery-token-ca-cert-hash sha256:[HASH] - само, че попълнена
- exit

* Следваща стъпка е да инсталираме мрежова политика в нашия случай се изисква инсталация на antrea (описание в занятие M3)
- в exam машината инсталираме с команда **НО ВЪВ ПРАВИЛНИЯ КОНТЕКСТ (Клъстър) - Venus**: kubectl apply -f https://raw.githubusercontent.com/antrea-io/antrea/main/build/yamls/antrea.yml
* Разрешаване на workloads на CP нода - чрез taints (занятие M5)
- kubectl describe node | grep Taints
- kubectl taint nodes [Име на node-a] node-role.kubernetes.io/control-plane:NoSchedule-
* Следващата задача трябва да деплойнем обекта в дадения yaml файл на всеки един от нодовете. 
В случая ни е даден yaml на pod ние трябва да го модифицираме на DaemonSet (M5) в случая.
- копираме In манифеста в out: cp -v /files/venus/t305-in.yaml /files/venus/t305-out.yaml
- vi /files/venus/t305-out.yaml
#Manifest#
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ds305
spec: 
  selector:
    matchLabels: 
      app: ds305
  template:
    metadata:
      labels: 
        app: ds305
    spec:
      containers:
      - name: main
        image: alpine
		name: main
		args:
		- /bin/sh
		- -c
		- sleep 86400

- kubectl apply -f /files/venus/t305-out
