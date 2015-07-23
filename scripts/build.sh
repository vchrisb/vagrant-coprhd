#!/bin/bash

# build CoprHD
cd /tmp
git clone https://github.com/CoprHD/coprhd-controller.git
cd coprhd-controller
make clobber BUILD_TYPE=oss rpm
rm -rf /vagrant/*.rpm
cp -a /tmp/coprhd-controller/build/RPMS/x86_64/storageos-*.x86_64.rpm /vagrant
