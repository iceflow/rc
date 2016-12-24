#!/bin/bash


/usr/sbin/openvpn --cd /etc/openvpn --daemon --config /etc/openvpn/client.conf
/usr/sbin/openvpn --cd /etc/openvpn --daemon --config /etc/openvpn/client-tw.conf




nohup /etc/openvpn/vpn_monitor.sh &
