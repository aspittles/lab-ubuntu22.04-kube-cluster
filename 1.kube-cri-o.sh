#Source: https://www.howtoforge.com/how-to-install-cri-o-container-runtime-on-ubuntu-22-04/

export OS=xUbuntu_22.04
export CRIO_VERSION=1.24

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/"$OS"/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/"$CRIO_VERSION"/"$OS"/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:"$CRIO_VERSION".list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:"$CRIO_VERSION"/"$OS"/Release.key | sudo apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/"$OS"/Release.key | sudo apt-key add -

sudo apt update

# sudo apt info cri-o

sudo apt-get install -y cri-o cri-o-runc

sudo systemctl start crio
sudo systemctl enable crio

# sudo systemctl status crio

sudo apt-get install -y containernetworking-plugins

sudo sed -i.bak 's/# network_dir =/network_dir =/' /etc/crio/crio.conf
sudo sed -i.bak 's/# plugin_dirs = \[/plugin_dirs = \[\n     "\/opt\/cni\/bin\/", \n     "\/usr\/lib\/cni\/",\n\]/' /etc/crio/crio.conf

##sudo nano /etc/crio/crio.conf
#[crio.network]
#
## The default CNI network name to be selected. If not set or "", then
## CRI-O will pick-up the first one found in network_dir.
## cni_default_network = ""
#
## Path to the directory where CNI configuration files are located.
## network_dir = "/etc/cni/net.d/"
#
## Paths to directories where CNI plugin binaries are located.
## plugin_dirs = [
##       "/opt/cni/bin/",
## ]

# A necessary configuration for Prometheus based metrics retrieval
sudo rm -f /etc/cni/net.d/100-crio-bridge.conf
sudo curl -fsSLo /etc/cni/net.d/11-crio-ipv4-bridge.conf https://raw.githubusercontent.com/cri-o/cri-o/main/contrib/cni/11-crio-ipv4-bridge.conflist

sudo systemctl restart crio
#sudo systemctl status crio

sudo apt-get install -y cri-tools
