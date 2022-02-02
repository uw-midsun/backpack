apt-get update

echo "==> Install general tools"
apt-get -y install tmux git vim curl scons

echo "==> Install python tooling"
apt-get -y install python3-pip
apt-get -y install pylint
apt-get -y install python3-autopep8
apt-get -y install virtualenv

echo "==> Install tooling for CAN"
apt-get -y install can-utils
python3 -m pip install python-can
python3 -m pip install cantools

echo "==> Install go"
wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -O go-zip.tar.gz
tar -xzf go-zip.tar.gz -C /usr/local
echo 'PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'GOPATH=/home/vagrant/go' >> /home/vagrant/.bashrc
rm go*.tar.gz

echo "==> Install ruby"
apt-get -y install ruby

echo "==> Install clang and gcc"
apt-get -y install gcc-8
apt-get -y install clang-10
apt-get -y install clang-format-10
ln -sf $(which gcc-8) /usr/bin/gcc
ln -sf $(which clang-10) /usr/bin/clang
ln -sf $(which clang-format-10) /usr/bin/clang-format

echo "==> Install arm gcc"
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2 -O arm-gcc.tar.bz2
tar xfj arm-gcc.tar.bz2 -C /usr/local
echo 'PATH=$PATH:/usr/local/gcc-arm-none-eabi-8-2019-q3-update/bin' >> /etc/profile
rm arm-gcc.tar.bz2

echo "==> Install other toolchain pieces"
apt-get -y install minicom
apt-get -y install openocd

echo "==> Setup for minicom"
touch /etc/minicom/minirc.dfl
echo "pu addcarreturn    Yes"


echo "==> Install protobuf things"
apt-get -y install software-properties-common
apt-get -y install protobuf-compiler
apt-get -y install golang-goprotobuf-dev
python3 -m pip install protobuf

echo "==> Install protobuf-c"
apt-get -y install autoconf
apt-get -y install libtool
apt-get -y install pkg-config
apt-get -y install libprotoc-dev
git clone https://github.com/protobuf-c/protobuf-c
cd protobuf-c
./autogen.sh
./configure
make
make install
ldconfig
cd /home/vagrant
rm -rf protobuf-c
