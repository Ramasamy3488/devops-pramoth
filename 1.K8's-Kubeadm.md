 # Kubernetes Architecture and Components

![kubernetes Architecture](https://www.aquasec.com/wp-content/uploads/2020/11/Kubernetes-101-Architecture-Diagram.jpg) 

## Control/Master Node Components:
- kube-apiserver
- etcd
- kube-controller/cloud-controller
- kube-scheduler
- kubelet
- kube-proxy
- CRI(Container Runtime Interface) docker, containerd, cri-o etc.,

## Compute/Worker Node Components:
- kubelet
- kube-proxy
- CRI(Container Runtime Interface) docker(depricated from 1.22), containerd, cri-o etc.,

![containerd](https://kubernetes.io/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/cri-containerd.png)

![kubelet](https://d33wubrfki0l68.cloudfront.net/cbb16af935843386c15e9a7f2c13fd383fea7599/9065d/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/docker-ce.png) 




# Launch 2 Instances with Minimum System Requirements

## System Requirements
- **OS:** Ubuntu 24.04 LTS server
- **RAM:** 2GB or more
- **Disk:** 20GB+
- **CPU:** 2 cores or more
- **Swap Memory:** Disable

### Disable Swap Temporarily
```bash
sudo swapoff -a
``` 
### Disable Swap Permanently 
```bash 
sudo vi /etc/fstab
# Comment the below line
UUID=<some-uuid> none swap sw 0
sudo reboot
```
## Run Below Commands on Both Master and Worker Nodes
 ``` bash
apt update && apt upgrade -y
#Check if the System Needs Reboot
cat /var/run/reboot-required
# Load Necessary Kernel Modules

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
# overlay: Enables the overlayfs kernel module, which is required for container images.
# br_netfilter: Enables the bridge netfilter kernel module, which is necessary for Kubernetes networking features like inter-pod communication.

## Setup Required Sysctl Parameters

cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

```
## Install containerd on both Master and worker 

``` bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

#Add the Docker repository

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install containerd.io -y

Configure Containerd

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# Configure crictl CLI
Create the crictl configuration file

cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
EOF


```

## Install Kubernetes Packages on All Nodes 

#Update the package index and install required packages 

``` bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download the public signing key for the Kubernetes package repositories

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

#Add the Kubernetes apt repository:

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update the apt package index and install Kubernetes components

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

```
## Run Below Commands on Master Node Alone

``` bash
kubeadm init --pod-network-cidr=10.244.0.0/16

#You will receive a token to join worker nodes to the master node. Copy and paste this token into a notepad.

# Example : Dont copy this kubeadm join 172.31.30.229:6443 --token cz9cwu.2muc1x6gqz4d7d6f \
#        --discovery-token-ca-cert-hash sha256:1836752e4fbf1411263019edaecd13a53241f73eab06b5440bffe476f3dcb986

#Install Calico Network Plugin
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml

#Note ***** Before applying the custom resources, modify the CIDR value in custom-resources.yaml.

kubectl apply -f custom-resources.yaml
```

## Verify Pods
``` bash 
watch kubectl get pods -n calico-system

watch kubectl get pods --all-namespaces


```

### if your running in single node Arch 

``` bash

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

```
### References 

- [crictl](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)
- [containerd](https://kubernetes.io/blog/2018/05/24/kubernetes-containerd-integration-goes-ga/)
- [Docker and Containerd](https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/check-if-dockershim-deprecation-affects-you/)- 
 
 






