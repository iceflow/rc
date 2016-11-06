# Goal:

Access Clients (l2tp/IPsec) <-> China Access Point <--- OpenVPN tun tunnel --> Global Access Point --> Global Resources


# China Access Point:
OS: Ubuntu 14.04.3 LTS
```Bash
1. xl2tpd
2. openswan
3. OpenVpn Client
4. iptables rules: NAT policies
5. route control scripts
```

# Global Access Point
OS: Ubuntu 14.04.3 LTS
```Bash
1. OpenVPN Server
2. iptables rules: NAT plicy
```

# Ref:
* xl2tpd:
	* https://github.com/xelerance/xl2tpd
* OpenSwan:
	* https://github.com/xelerance/openswan
* OpenVPN:
	* https://help.ubuntu.com/community/OpenVPN
	* https://openvpn.net/index.php/open-source/documentation/howto.html
	* https://openvpn.net/index.php/open-source/documentation/howto.html#examples

# Progress
* Global Access Point Setup
	* Install OpenVPN Server
```Bash
# Installation
apt-get install openvpn
```
	* Generate Server and Clients CAs
		* ref: https://openvpn.net/index.php/open-source/documentation/howto.html#pki
	* OpenVPN Server configuration files
```Bash
# cat /etc/openvpn/server.conf
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret
dh dh2048.pem
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
duplicate-cn
keepalive 10 120
comp-lzo
persist-key
persist-tun
status openvpn-status.log
verb 3
```
	* Start openvpn server
```Bash
# service openvpn start
```
	* iptables NAT rules
``` Bash
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
```
	* Adding to OS bootstrap
		* /etc/rc.local
		* rc3.d services
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




