#!/bin/bash

# Install VBoxGuestAdditions
version=`curl --silent https://download.virtualbox.org/virtualbox/LATEST.TXT`
curl https://download.virtualbox.org/virtualbox/$version/VBoxGuestAdditions_$version.iso -o /tmp/VBoxGuestAdditions.iso
mount /tmp/VBoxGuestAdditions.iso /mnt -o loop
/mnt/VBoxLinuxAdditions.run

# Clean all
yum clean all

# Install vagrant default key
mkdir -pm 700 /home/vagrant/.ssh
curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh


# Remove temporary files
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /vagrant/home/*.iso
rm  -f ~/.bash_history
history -c
rm -rf /run/log/journal/*

# Fill zeros all empty space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
