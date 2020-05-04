#!/bin/bash

# Update system
yum update -y

# Install required packages
yum install -y make gcc bc bison flex elfutils-libelf-devel openssl-devel grub2 perl bzip2 wget

# Get 5.6.8 kernel
cd /usr/src

wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.8.tar.xz
tar -xvf linux-5.6.8.tar.xz
ln -s linux-5.6.8 linux
cd linux
# Compile new kernel
make olddefconfig
make all -j 8 && make modules_install && make install
rm -f /boot/*3.10*

# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
#echo "Grub update done."

# Reboot VM
shutdown -r now
