#!/bin/bash

cp /vagrant/epel-6.repo /etc/yum.repos.d/
setenforce 0
yum -y --nogpgcheck install rpmdevtools mock git svn
usermod -a -G mock vagrant
iptables -t mangle -A OUTPUT  -j DSCP --set-dscp-class CS2
iptables-save
git clone https://github.com/skottler/zookeeper-rpms
cd /home/vagrant/zookeeper-rpms
rpmdev-setuptree
echo "Running spectool......."
echo $(pwd)
spectool -g zookeeper.spec 2> /dev/null
echo "Running rpmbuild to generate sourece rpm ......."
rpmbuild -bs --nodeps --define "_sourcedir $(pwd)" --define "_srcrpmdir $(pwd)" zookeeper.spec
echo "Running mock ......."
sudo mock --disable-plugin=selinux zookeeper-3.4.6-2.src.rpm #2> /dev/null
cat /var/lib/mock/epel-6-x86_64/result/build.log
cat /var/lib/mock/epel-6-x86_64/result/state.log
echo "Creating upload directory on nfs share ......."
mkdir -p /vagrant/epel-6-x86_64/rpms
echo "Copying generated RPMs from Vagrant box to nfs share ......."
cp /var/lib/mock/epel-6-x86_64/result/*.x86_64.rpm /vagrant/epel-6-x86_64/rpms
echo "Done !!!......."
