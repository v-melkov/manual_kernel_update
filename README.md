stage-1
-----

### Обновляем систему
    yum update -y

### Устанавливаем необходимые для компиляции ядра пакеты
    yum install -y make gcc bc bison flex elfutils-libelf-devel openssl-devel grub2 perl bzip2 wget

### Скачиваем ядро 5.6.8 с сайта kernel.org, распаковываем его и делаем симлинк
    cd /usr/src
    wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.8.tar.xz
    tar -xvf linux-5.6.8.tar.xz
    ln -s linux-5.6.8 linux
    cd linux

### Компилируем скачанное ядро предварительно создав .config со значениями по умолчанию
    make olddefconfig
    make all -j 8 && make modules_install && make install

### Удалим старое ядро из системы 
    rm -f /boot/*3.10*

### Обновим загрузчик
    grub2-mkconfig -o /boot/grub2/grub.cfg
    grub2-set-default 0

### Перезагрузка
    shutdown -r now


stage-2
-----
### Устанавливаем последние VBoxGuestAdditions
    version=`curl --silent https://download.virtualbox.org/virtualbox/LATEST.TXT`
    curl https://download.virtualbox.org/virtualbox/$version/VBoxGuestAdditions_$version.iso -o /tmp/VBoxGuestAdditions.iso
    mount /tmp/VBoxGuestAdditions.iso /mnt -o loop
    /mnt/VBoxLinuxAdditions.run


### Clean all
    yum clean all

### Install vagrant default key
    mkdir -pm 700 /home/vagrant/.ssh
    curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh


### Remove temporary files
    rm -rf /tmp/*
    rm  -f /var/log/wtmp /var/log/btmp
    rm -rf /var/cache/* /usr/share/doc/*
    rm -rf /var/cache/yum
    rm -rf /vagrant/home/*.iso
    rm  -f ~/.bash_history
    history -c
    rm -rf /run/log/journal/*

### Fill zeros all empty space
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY
    sync
