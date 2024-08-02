#!/bin/bash


# Variables
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME}"
STORAGE_ACCOUNT_KEY="${STORAGE_ACCOUNT_KEY}"
CONTAINER_NAME="${CONTAINER_NAME}"

# Log file
LOG_FILE="/var/log/worker-script.log"
# Redirect stdout and stderr to the log file
exec > >(tee -a ${LOG_FILE}) 2>&1


# Install necessary packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#!/bin/bash

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Update sysctl settings for Kubernetes networking
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's|registry.k8s.io/pause:3.8|registry.k8s.io/pause:3.9|g' /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl enable --now containerd

# Add Kubernetes apt repository
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubeadm, kubelet, and kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# Install crictl-tools
VERSION="v1.30.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Storage Account Key: $STORAGE_ACCOUNT_KEY"
echo "Container Name: $CONTAINER_NAME"

az storage blob download \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $STORAGE_ACCOUNT_KEY \
    --container-name $CONTAINER_NAME \
    --name joincluster.sh \
    --file /home/azureuser/joincluster.sh

# Join the Kubernetes cluster
sudo chmod +x /home/azureuser/joincluster.sh
sudo bash /home/azureuser/joincluster.sh --cri-socket /run/containerd/containerd.sock

