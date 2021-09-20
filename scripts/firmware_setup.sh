# Install clang and gcc
apt-get -y install gcc-6
apt-get -y install clang-5.0
apt-get -y install clang-format-5.0
ln -sf $(which gcc-6) /usr/bin/gcc
ln -sf $(which clang-5.0) /usr/bin/clang
ln -sf $(which clang-format-5.0) /usr/bin/clang-format

# Install arm gcc
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -O arm-gcc.tar.bz2
tar xfj arm-gcc.tar.bz2 -C /usr/local
echo 'PATH=$PATH:/usr/local/gcc-arm-none-eabi-6-2017-q2-update/bin' >> /etc/profile
rm arm-gcc.tar.bz2

# Install other toolchain pieces
apt-get -y install minicom
apt-get -y install openocd

# Setup for minicom
touch /etc/minicom/minirc.dfl
echo "pu addcarreturn    Yes"

# Install protobuf-c
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
