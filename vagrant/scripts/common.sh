#!/usr/bin/env bash

if [ -z ${K8S_VERSION+x} ]; then
  K8S_VERSION=1.23.6-00
fi

# Update package index and install dependencies
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Add containerd repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# Update package index again
apt-get update

# Install packages
apt-get install -y \
  avahi-daemon \
  libnss-mdns \
  traceroute \
  htop \
  httpie \
  bash-completion \
  containerd \
  kubeadm=$K8S_VERSION \
  kubelet=$K8S_VERSION \
  kubectl=$K8S_VERSION

# Configure containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd to apply the changes
systemctl restart containerd
systemctl enable containerd

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Enable and start kubelet
systemctl enable kubelet
systemctl start kubelet

# Set alias for kubectl command
echo "alias k=kubectl" >> /home/vagrant/.bashrc

