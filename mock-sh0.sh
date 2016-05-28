#!/bin/bash

sudo cp /vagrant/epel-6.repo /etc/yum.repos.d/
sudo setenforce 0
sudo yum -y --nogpgcheck install rpmdevtools mock git svn
sudo usermod -a -G mock vagrant
sudo iptables -t mangle -A OUTPUT  -j DSCP --set-dscp-class CS2
sudo iptables-save
#    sudo cd /root
#    sudo cp -r /vagrant/zookeeper-rpms .
sudo git clone https://github.com/skottler/zookeeper-rpms
cd /home/vagrant/zookeeper-rpms
sudo rpmdev-setuptree
echo "Running spectool......."
echo $(pwd)
sudo spectool -g zookeeper.spec 2> /dev/null
echo "Running rpmbuild to generate sourece rpm ......."
sudo rpmbuild -bs --nodeps --define "_sourcedir $(pwd)" --define "_srcrpmdir $(pwd)" zookeeper.spec
echo "Running mock ......."
sudo mock --disable-plugin=selinux zookeeper-3.4.8-1.el6.src.rpm  --resultdir=/vagrant/"%(target_arch)s"/"%(releasever)s"/

cat /var/lib/mock/epel-6-x86_64/result/build.log
cat /var/lib/mock/epel-6-x86_64/result/state.log
echo "Creating upload directory on nfs share ......."
sudo mkdir -p /vagrant/epel-6-x86_64/rpms
echo "Copying generated RPMs from Vagrant box to nfs share ......."
sudo cp /var/lib/mock/epel-6-x86_64/result/*.x86_64.rpm /vagrant/epel-6-x86_64/rpms
echo "Done !!!......."
