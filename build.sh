#!/bin/bash

# build CoprHD
cd /tmp
git clone https://github.com/CoprHD/coprhd-controller.git
cd coprhd-controller
make clobber BUILD_TYPE=oss rpm