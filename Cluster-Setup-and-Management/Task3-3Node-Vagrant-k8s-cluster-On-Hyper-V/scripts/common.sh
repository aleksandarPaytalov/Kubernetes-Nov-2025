#!/bin/bash
#
# common.sh - Common setup script for all Kubernetes nodes
# This script runs on master and worker nodes
#

set -euxo pipefail

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

echo "=========================================="
echo "Starting Common Node Setup"
echo "=========================================="

# Update system packages
echo "[TASK 1] Update system packages"
apt-get update -qq
apt-get upgrade -y -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Install required packages
echo "[TASK 2] Install required packages"
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    net-tools \
    vim \
    git

# Disable swap (required by Kubernetes)
echo "[TASK 3] Disable swap"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load required kernel modules
echo "[TASK 4] Load kernel modules"
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Configure sysctl parameters for Kubernetes
echo "[TASK 5] Configure sysctl parameters"
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# Install containerd
echo "[TASK 6] Install containerd runtime"
apt-get update -qq
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" containerd

# Configure containerd
echo "[TASK 7] Configure containerd"
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

# Enable systemd cgroup driver
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd
systemctl enable containerd

# Add Kubernetes repository
echo "[TASK 8] Add Kubernetes repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
echo "[TASK 9] Install kubeadm, kubelet, and kubectl"
apt-get update -qq
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Enable kubelet service
echo "[TASK 10] Enable kubelet service"
systemctl enable kubelet

# Pull Kubernetes images (speeds up cluster initialization)
echo "[TASK 11] Pull Kubernetes container images"
kubeadm config images pull

# Configure crictl to use containerd
echo "[TASK 12] Configure crictl"
cat <<EOF | tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
EOF

# Update /etc/hosts for cluster nodes
echo "[TASK 13] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.0.10   k8s-master.local k8s-master
192.168.0.11   k8s-worker1.local k8s-worker1
192.168.0.12   k8s-worker2.local k8s-worker2
EOF

echo "=========================================="
echo "Common Node Setup Completed Successfully"
echo "=========================================="
