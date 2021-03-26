# Configure sudoers
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;
sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers;

# Add public key to enable ssh without password
pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";
mkdir -p /home/vagrant/.ssh
wget --no-check-certificate "$pubkey_url" -O /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Install packages required for building guest additions
apt-get -y update
apt-get -y install build-essential linux-headers-generic perl
apt-get -y install nfs-common dkms

# Configure guest additions to enable shared folder
VBOX_VER=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VER.iso /mnt
sh /mnt/VBoxLinuxAdditions.run || echo "suppressing $? from guest additions"
umount /mnt
rm -f /home/vagrant/*.iso
rm /home/vagrant/.vbox_version

# Install general tools
apt-get -y install tmux git vim curl

# Install python tooling
apt-get -y install python3-pip
apt-get -y install pylint
apt-get -y install python-autopep8
apt-get -y install virtualenv

# Install tooling for CAN
apt-get -y install can-utils
python3 -m pip install python-can
python3 -m pip install cantools

# Install go
wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -O go-zip.tar.gz
tar -xzf go-zip.tar.gz -C /usr/local
echo 'PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'GOPATH=/home/vagrant/go' >> /home/vagrant/.bashrc
rm go*.tar.gz

# Install ruby
apt-get -y install ruby

# Install protobuf things
apt-get -y install software-properties-common
add-apt-repository -y ppa:maarten-fonville/protobuf
apt-get -y install protobuf-compiler
python3 -m pip install protobuf
apt-get -y install golang-goprotobuf-dev
