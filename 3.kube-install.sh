# Initialise the Kubernetes Master Plane
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Make Kube Config file available to local user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install the Network Plugin
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# Useful command to run and watch every thing come up
echo watch kubectl get all -A -o wide
