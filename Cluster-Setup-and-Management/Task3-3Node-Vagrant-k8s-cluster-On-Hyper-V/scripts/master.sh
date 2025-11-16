#!/bin/bash
#
# master.sh - Master node setup script
# This script initializes the Kubernetes control plane
#

set -euxo pipefail

echo "=========================================="
echo "Starting Master Node Setup"
echo "=========================================="

# Initialize Kubernetes cluster
echo "[TASK 1] Initialize Kubernetes cluster"
kubeadm init \
  --apiserver-advertise-address=192.168.0.10 \
  --pod-network-cidr=10.244.0.0/16 \
  --node-name=k8s-master \
  --ignore-preflight-errors=all >> /root/kubeinit.log 2>&1

# Configure kubectl for root user
echo "[TASK 2] Configure kubectl for root user"
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown root:root /root/.kube/config

# Configure kubectl for vagrant user
echo "[TASK 3] Configure kubectl for vagrant user"
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# Export KUBECONFIG for current session
export KUBECONFIG=/etc/kubernetes/admin.conf

# Install Flannel CNI plugin
echo "[TASK 4] Install Flannel CNI network plugin"
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml >/dev/null 2>&1

# Wait for Flannel pods to be ready
echo "[TASK 5] Wait for Flannel pods to be ready"
kubectl wait --namespace kube-flannel --for=condition=ready pod --selector=app=flannel --timeout=300s >/dev/null 2>&1 || true

# Generate cluster join command
echo "[TASK 6] Generate cluster join command"
# Save join command locally on master
mkdir -p /tmp/k8s-setup
kubeadm token create --print-join-command > /tmp/k8s-setup/join-command.sh
chmod +x /tmp/k8s-setup/join-command.sh

# Start a simple HTTP server to share the join command with workers
echo "[TASK 7] Start HTTP server to share join command"
cd /tmp/k8s-setup
nohup python3 -m http.server 8000 > /tmp/http-server.log 2>&1 &
echo "HTTP server started on port 8000"
echo "Join command available at: http://192.168.0.10:8000/join-command.sh"

# Display the join command for reference
echo "[TASK 8] Join command for workers:"
cat /tmp/k8s-setup/join-command.sh

# Create a script to display cluster information
echo "[TASK 9] Create cluster info script"
cat <<'EOF' > /home/vagrant/cluster-info.sh
#!/bin/bash
echo "=========================================="
echo "Kubernetes Cluster Information"
echo "=========================================="
echo ""
echo "Cluster Nodes:"
kubectl get nodes -o wide
echo ""
echo "System Pods:"
kubectl get pods -n kube-system
echo ""
echo "Cluster Info:"
kubectl cluster-info
echo ""
echo "=========================================="
EOF

chmod +x /home/vagrant/cluster-info.sh
chown vagrant:vagrant /home/vagrant/cluster-info.sh

# Enable kubectl bash completion
echo "[TASK 10] Enable kubectl bash completion"
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
echo 'source <(kubectl completion bash)' >> /home/vagrant/.bashrc
echo 'alias k=kubectl' >> /home/vagrant/.bashrc
echo 'complete -o default -F __start_kubectl k' >> /home/vagrant/.bashrc

# Display cluster status
echo "[TASK 11] Display initial cluster status"
echo ""
echo "=========================================="
echo "Master Node Setup Completed"
echo "=========================================="
echo ""
kubectl get nodes
echo ""
echo "Join command saved to: /tmp/k8s-setup/join-command.sh"
echo "Also available via HTTP at: http://192.168.0.10:8000/join-command.sh"
echo "Workers will automatically download and use this command"
echo ""
echo "To check cluster status, run:"
echo "  vagrant ssh k8s-master"
echo "  kubectl get nodes"
echo "=========================================="
