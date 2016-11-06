# 4. Others:
l2tp/IPSec quick guide
https://github.com/sockeye44/instavpn
https://raymii.org/s/tutorials/IPSEC_L2TP_vpn_with_Ubuntu_14.04.html#Configure_xl2tpd

https://www.xelerance.com/

Login:
http://l2tp.armor5.cn:8080/
# Installation
curl -sS https://raw.githubusercontent.com/sockeye44/instavpn/master/instavpn.sh | sudo bash

# instavpn -h
usage: Instavpn CLI [-h] {list,psk,user,stat,web} ...

Instavpn CLI

positional arguments:
  {list,psk,user,stat,web}
    list                Show all credentials
    psk                 Get/set pre-shared key
    user                Create, modify and delete users
    stat                Bandwidth statistics
    web                 Control web UI


Installation:
1. Install OpenVPN: 
sudo apt-get -y install openvpn bridge-utils

2. Generating Certificates
sudo apt-get -y easy-rsa




