# Terraform GCP VM instances

export GOOGLE_APPLICATION_CREDENTIALS=/home/kaladin/Downloads/dogs23-4c3424f64ec5.json

terraform apply


# Set Up

ssh into master and nodes. Use tmux to synchronize commands across all workers and master


sudo swapoff -a
sudo sed -i.bak '/swap/d' /etc/fstab


sudo bash -c 'cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF'

sudo sysctl --system



sudo bash -c 'cat <<EOF > /etc/modules-load.d/containerd.conf 
overlay
br_netfilter
EOF'

sudo modprobe overlay
sudo modprobe br_netfilter


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