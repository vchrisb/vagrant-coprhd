#!/bin/bash

while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -vip|--virtual_ip)
    VIP="$2"
    shift
    ;;
    *)
    # unknown option
    ;;
  esac
  shift
done

# install CoprHD
rpm -U /tmp/coprhd-controller/build/RPMS/x86_64/storageos-*.x86_64.rpm

printf "Waiting for the CoprHD services to start..."
SERVICES="nginx storageos-api storageos-auth storageos-controller storageos-coordinator storageos-db storageos-portal"
TIMER=1
INTERVAL=10
while [[ "`systemctl is-active $SERVICES`" =~ "inactive" ]];
do
  if [ $TIMER -gt 300 ]; then
    echo ""
    echo "CoprHD Services did not start in a timely (300s) fashion!" >&2
    echo "Services start may have been delayed or failed." >&2
    echo "Issue 'vagrant destroy' followed by 'vagrant up' to restart deplyoment." >&2
    exit 1
  fi
  printf "."
  sleep $INTERVAL
  let TIMER=TIMER+$INTERVAL
done

echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#    Please open your browser and connect to CoprHD     #"
echo "#                                                       #"
echo "#                https://$VIP                 #"
echo "#                Username: root                         #"
echo "#                Password: ChangeMe                     #"
echo "#                                                       #"
echo "#########################################################"
