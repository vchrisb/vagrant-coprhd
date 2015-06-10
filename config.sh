#!/bin/bash

while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -ip|--node_ip)
    IP="$2"
    shift
    ;;
    -vip|--virtual_ip)
    VIP="$2"
    shift
    ;;
    -gw|--gw_ip)
    GW="$2"
    shift
    ;;
	-count|--node_count)
    COUNT="$2"
    shift
    ;;
	-id|--node_id)
    ID="$2"
    shift
    ;;
    *)
    # unknown option
    ;;
  esac
  shift
done

#add required users and groups
groupadd storageos
useradd -d /opt/storageos -g storageos storageos

#create config file
cat > /etc/ovfenv.properties << EOF
network_1_ipaddr6=::0
network_1_ipaddr=$IP
network_gateway6=::0
network_gateway=$GW
network_netmask=255.255.255.0
network_prefix_length=64
network_vip6=::0
network_vip=$VIP
node_count=$COUNT
node_id=$ID
EOF

