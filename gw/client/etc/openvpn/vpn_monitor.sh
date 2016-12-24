#!/bin/bash

LOG=/var/log/vpn_monitor.log


function do_log()
{
	TIME=`date +"%Y-%m-%d %T"`
	echo "$TIME $1" >> $LOG
}

function flush_gw_route()
{
	/sbin/ip route add default via 10.8.1.1 table tw
	/sbin/ip route fulsh cache
}

while [ 1 ]; do


	if [ `ip route list table tw  | grep -c 10.8.1.1` -eq 0 ]; then
		flush_gw_rotue

	fi


	sleep 60
done
