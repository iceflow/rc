
# Goal:

Access Clients (l2tp/IPsec) <-> China Access Point <--- OpenVPN tun tunnel --> Global Access Point --> Global Resources


# China Access Point:
OS: Ubuntu 14.04.3 LTS
1. xl2tpd
2. openswan
3. OpenVpn Client
4. iptables rules: NAT policies
5. route control scripts

# Global Access Point
OS: Ubuntu 14.04.3 LTS
1. OpenVPN Server
2. iptables rules: NAT plicy

# Ref:
* xl2tpd:
https://github.com/xelerance/xl2tpd
* OpenSwan:
https://github.com/xelerance/openswan
* OpenVPN:
https://help.ubuntu.com/community/OpenVPN
https://openvpn.net/index.php/open-source/documentation/howto.html
https://openvpn.net/index.php/open-source/documentation/howto.html#examples

# Progress
* Global Access Point Setup
* China Access Point Setup
* Access Clients Setup

# Others:
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




