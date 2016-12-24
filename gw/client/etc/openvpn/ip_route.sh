#!/bin/bash

# 137
#32760:  from 172.16.1.136 lookup 2
#32761:  from 172.16.1.135 lookup 2
#32762:  from 172.16.1.134 lookup 2
#32763:  from 172.16.1.133 lookup 2
#32764:  from 172.16.1.129 lookup 2


TW_LIST="172.16.1.129 172.16.1.133 172.16.1.134 172.16.1.135 172.16.1.136 172.16.1.137 172.16.1.138 172.16.1.139 10.100.0.0/24"

## Table 1 (jp) : All traffic to openvpn peer
ip route add default via 10.8.0.1 table 1
## Table 2 (tw) : All traffic to openvpn peer through gcloud(TW)
ip route add default via 10.8.1.1 table 2

## ip rule
for IP in ${TW_LIST}; do
	ip rule add from $IP table tw
done
ip route flush cache
