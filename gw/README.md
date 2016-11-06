# Goal:

Access Clients (l2tp/IPsec) <-> China Access Point <--- OpenVPN tun tunnel --> Global Access Point --> Global Resources

* China Access Point:
```Bash
Local Subnet: 172.31.0.0/20
Mobile pool: 172.16.1.0/24
openvpn subnet: 10.8.0.0/24
```
* Global Access Point:
```Bash
Local Subnet: 192.168.0.0/24
```

# 1. Components
## 1) China Access Point:
OS: Ubuntu 14.04.3 LTS
```Bash
1. xl2tpd
2. openswan
3. OpenVpn Client
4. iptables rules: NAT policies
5. route control scripts
```

## 2) Global Access Point
OS: Ubuntu 14.04.3 LTS
```Bash
1. OpenVPN Server
2. iptables rules: NAT plicy
```

# 2. References:
* xl2tpd:
  * https://github.com/xelerance/xl2tpd
* OpenSwan:
  * https://github.com/xelerance/openswan
* OpenVPN:
  * https://help.ubuntu.com/community/OpenVPN
  * https://openvpn.net/index.php/open-source/documentation/howto.html
  * https://openvpn.net/index.php/open-source/documentation/howto.html#examples

# 3. Progresses
## 1) Global Access Point Setup
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
  
## 2) China Access Point Setup
* Install OpenVPN client and l2tp/IPSec server
```Bash
# Installation
apt-get install openvpn xl2tpd openswan
```
* OpenVPN Client configuration
```Bash
# Getting client CA(Certificate and key from Server side), such as client.crt, client.key
# cat /etc/openvpn/client.conf
client
dev tun
proto udp
remote global_server_ip_or_domain_name 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert client.crt
key client.key
remote-cert-tls server
comp-lzo
verb 3

```
* Start OpenVPN Client
```Bash
/usr/sbin/openvpn --cd /etc/openvpn --daemon --config /etc/openvpn/client.conf
```
* xl2tpd Server setup
```Bash
# cat /etc/xl2tpd/xl2tpd.conf
[global]
ipsec saref = yes
saref refinfo = 30

;debug avp = yes
;debug network = yes
;debug state = yes
;debug tunnel = yes

[lns default]
ip range = 172.16.1.30-172.16.1.100
local ip = 172.16.1.1
refuse pap = yes
require authentication = yes
;ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd

# cat /etc/ppp/options.xl2tpd
require-mschap-v2
ms-dns 8.8.8.8
ms-dns 8.8.4.4
auth
#mtu 1200
#mru 1000
mtu 1400
mru 1300
crtscts
hide-password
modem
name l2tpd
proxyarp
lcp-echo-interval 30
lcp-echo-failure 4
```

* Adding new access account
```Bash
# cat /etc/ppp/chap-secrets
dynamic_user l2tpd dynamic_password *
fix_user l2tpd fix_password 172.16.1.130
```

* Start xl2tpd server
```Bash
service xl2tpd start
```

* Openswan setup
```Bash
# cat /etc/ipsec.conf
version 2

config setup
    dumpdir=/var/run/pluto/
    nat_traversal=yes
    virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v6:fd00::/8,%v6:fe80::/10
    protostack=netkey
    force_keepalive=yes
    keep_alive=60

conn L2TP-PSK-noNAT
    authby=secret
    pfs=no
    auto=add
    keyingtries=3
    ikelifetime=8h
    keylife=1h
    ike=aes256-sha1,aes128-sha1,3des-sha1
    phase2alg=aes256-sha1,aes128-sha1,3des-sha1
    type=transport
    left=172.31.*.*
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any
    dpddelay=10
    dpdtimeout=20
    dpdaction=clear

# cat /etc/ipsec.secrets
172.31.*.* %any: PSK "test"

```
* Start openswan server
```Bash
service openswan start
```
* iptables and ip route rules
```Bash
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth+ -j SNAT --to-source 172.31.7.176
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o tun0 -j MASQUERADE

## Adding Destinations ip/nets to openvpn peer
# Facebook . For examples
REMOUTE_NETS="31.13.0.0/16"

# Twitter
REMOUTE_NETS="${REMOUTE_NETS} 104.244.0.0/14"

for NET in ${REMOUTE_NETS}; do
        /sbin/ip route add $NET via 10.8.0.1 metric 100
done

## Using ip rules to select different custom routing tables
## Table 1 (all) : All traffic to openvpn peer
ip route add default via 10.8.0.1 table 1

## ip rule
ip rule add from 172.16.1.128/25 table 1
ip route flush cache
```

* Adding to OS bootstrap
  * /etc/rc.local
  * rc3.d services

## 3) Access Clients Setup
* Mobile IOS [TODO]
* Mac OSX [TODO]
