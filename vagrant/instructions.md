## Pre-requirements
**Install Vagrant & Virtual Box:**
[VirtualBox-Homepage](https://www.virtualbox.org/wiki/Downloads "Virtual Box")
```
sudo apt update
sudo apt upgrade
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
sudo apt-get -y install vagrant

Put the following on Vagrantfile to disable sync folders:

config.vm.synced_folder ".", "/vagrant", disabled: true

```

NOTE: Start the VMs using the command vagrant up. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command vagrant destroy -f. The Kubernetes cluster consists of a control plane node running on kube-control-plane and kube-worker-1. 

You can SSH into a VM using the command vagrant ssh <vm-name>.
