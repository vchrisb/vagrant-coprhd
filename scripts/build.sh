#!/bin/bash
while [[ $# > 1 ]]
do
  key="$1"
  case $key in
    -b|--build)
      build="$2"
      shift
      ;;
    *)
      # unknown option
      ;;
  esac
  shift
done

if [ "$build" = true ] || [ ! -e /vagrant/*.rpm ]; then
  # build CoprHD
  cd /tmp
  git clone https://github.com/CoprHD/coprhd-controller.git
  cd coprhd-controller
  make clobber BUILD_TYPE=oss rpm
  rm -rf /vagrant/*.rpm
  cp -a /tmp/coprhd-controller/build/RPMS/x86_64/storageos-*.x86_64.rpm /vagrant
fi
