#!/bin/bash
#
# worker.sh - Worker node setup script
# This script joins the worker node to the Kubernetes cluster
#

set -euxo pipefail

echo "=========================================="
echo "Starting Worker Node Setup"
echo "=========================================="

# Wait for master to be ready and download join command
echo "[TASK 1] Wait for master node and download join command"
# Wait for master's HTTP server to be available
MAX_RETRIES=60
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f -s http://192.168.0.10:8000/join-command.sh -o /tmp/join-command.sh; then
        echo "Successfully downloaded join command from master!"
        chmod +x /tmp/join-command.sh
        break
    fi
    echo "Waiting for master node HTTP server... (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"
    sleep 10
    RETRY_COUNT=$((RETRY_COUNT + 1))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "ERROR: Could not download join command from master after $MAX_RETRIES attempts"
    exit 1
fi

echo "Join command ready!"
sleep 5

# Join the cluster
echo "[TASK 2] Join Kubernetes cluster"
bash /tmp/join-command.sh >> /root/kubejoin.log 2>&1

# Enable kubectl bash completion (optional for workers)
echo "[TASK 3] Enable kubectl bash completion"
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null 2>/dev/null || true
echo 'alias k=kubectl' >> /home/vagrant/.bashrc

echo ""
echo "=========================================="
echo "Worker Node Setup Completed"
echo "=========================================="
echo ""
echo "This node has joined the cluster."
echo "To verify, run on master node:"
echo "  vagrant ssh k8s-master"
echo "  kubectl get nodes"
echo "=========================================="
