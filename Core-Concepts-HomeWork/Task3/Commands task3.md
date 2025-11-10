#Commands Task 3#
Method 1: kubectl apply -k .

Method 2: kubectl apply -f . --server-side
#Note: Грешката от снимката при изпълнението на първата команда се дължи на това, че kubectl apply -f . се опитва да приложи
kustomization.yml, като обикновен Kubernetes манифест.