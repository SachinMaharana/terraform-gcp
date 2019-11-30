# Terraform GCP VM instances

export GOOGLE_APPLICATION_CREDENTIALS=/home/kaladin/Downloads/dogs23-4c3424f64ec5.json

terraform apply


# Set Up

1. ssh into master and nodes. Use tmux to synchronize commands across all workers and master


2.
 ```
sudo swapoff -a
```
   
   a. free -h

   b. blkid

   c. lsblk

   d. swapoff -a

3. 
```
sudo sed -i.bak '/swap/d' /etc/fstab
 ```
 sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstabxx


4.
```
sudo bash -c 'cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF'
```

5.

```
sudo sysctl --system
```


6.

```
sudo bash -c 'cat <<EOF > /etc/modules-load.d/containerd.conf 
overlay
br_netfilter
EOF'
```

7.

```
sudo modprobe overlay
sudo modprobe br_netfilter
```


sudo apt-get update
sudo apt-get install libseccomp2
wget https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.3.0.linux-amd64.tar.gz
sudo tar --no-overwrite-dir -C / -xzf cri-containerd-1.3.0.linux-amd64.tar.gz

sudo systemctl enable containerd && sudo systemctl start containerd

sudo mkdir -p /etc/containerd 

containerd config default > /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl restart containerd

sudo apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update 


apt-get install -y kubelet kubeadm kubectl

sudo systemctl enable kubelet  
sudo systemctl start kubelet

sudo vim /etc/systemd/system/kubelet.service.d/0-containerd.conf

[Service]                                                 
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock"

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# On Master

kubeadm init --pod-network-cidr 10.200.0.0/16 

Copy token to worker and execute.

kubeadm join 10.240.0.11:6443 --token lxp6ta.rez4pd6y564ua2z1 --discovery-token-ca-cert-hash sha256:62ec9cd864203b05a339110b33b039e80edf1e8f7ffef37eaeeab795c7f2b54a


kubectl apply -f flannel.yaml

# Tests

https://github.com/Mirantis/k8s-netchecker-server

kubectl get pods --namespace kube-system --output wide

kubectl cluster-info

kubectl get services -n kube-system







    1  containerd config default > /etc/containerd/config.toml
    2  setenforce 0
    3  sudo systemctl status firewalld
    4  sudo systemctl stop firewalld
    5  sudo systemctl status firewalld
    6  sudo systemctl disable firewalld
    7  sudo setenforce 0
    8  sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
    9  sudo systemctl daemon-reload
   10  sudo systemctl restart containerd
   11  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
   12  > [kubernetes]
   13  > name=Kubernetes
   14  > baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
   15  > enabled=1
   16  > gpgcheck=1
   17  > repo_gpgcheck=1
   18  > gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
   19  >         https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
   20  > EOF
   21  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
   22  [kubernetes]
   23  name=Kubernetes
   24  baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
   25  enabled=1
   26  gpgcheck=1
   27  repo_gpgcheck=1
   28  gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
   29          https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
   30  EOF
   31  yum update
   32  yum install -y kubelet kubeadm kubectl
   33  sudo systemctl enable kubelet
   34  systemctl enable kubelet
   35  systemctl start kubelet
   36  vim /etc/systemd/system/kubelet.service.d/0-containerd.conf
