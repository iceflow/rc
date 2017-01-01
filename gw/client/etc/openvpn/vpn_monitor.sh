#!/bin/bash

LOG=/var/log/vpn_monitor.log

TW_ROUTE=/etc/openvpn/tw_route.sh


function do_log()
{
	TIME=`date +"%Y-%m-%d %T"`
	echo "$TIME $1" >> $LOG
}

function refresh_jp_route()
{
	/sbin/ip route add default via 10.8.0.1 table jp
	/sbin/ip route fulsh cache
}

function refresh_tw_route()
{
	/sbin/ip route add default via 10.8.1.1 table tw
	/sbin/ip route fulsh cache
	[ -x ${TW_ROUTE} ] && ${TW_ROUTE}
}

while [ 1 ]; do


	CHG=0

	if [ `ip route list table jp  | grep -c 10.8.0.1` -eq 0 ]; then
		refresh_jp_route
		do_log "refresh_jp_route"
		CHG=1
	fi

	if [ `ip route list table tw  | grep -c 10.8.1.1` -eq 0 ]; then
		refresh_tw_rotue
		do_log "refresh_tw_route"
		CHG=1
	fi


	sleep 60
done


exit 0
