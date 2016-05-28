#!/bin/bash

sudo cp /vagrant/$3 /etc/yum.repos.d/
sudo setenforce 0
sudo yum -y --nogpgcheck install rpmdevtools mock git svn
sudo usermod -a -G mock vagrant
sudo iptables -t mangle -A OUTPUT  -j DSCP --set-dscp-class CS2
sudo iptables-save

sudo git clone $4
cd /home/vagrant/$5
sudo rpmdev-setuptree
cp -f /vagrant/$1 .
echo "Running spectool......."
echo $(pwd)
sudo spectool -g $1 2> /dev/null

#sudo spectool -g zookeeper.spec 2> /dev/null
echo "Running rpmbuild to generate sourece rpm ......."
sudo rpmbuild -bs --nodeps --define "_sourcedir $(pwd)" --define "_srcrpmdir $(pwd)" $1
echo "Running mock ......."
sudo mock --disable-plugin=selinux $2  --resultdir=/vagrant/"%(target_arch)s"/"%(releasever)s"/
echo "Done !!!......."
