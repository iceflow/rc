#!/bin/bash

# AWS BJS
REMOUTE_NETS="54.222.0.0/16 54.223.0.0/16"

# Pockerstar
REMOUTE_NETS="${REMOUTE_NETS}"

GW=172.31.0.1
TABLE=tw

for NET in ${REMOUTE_NETS}; do
	/sbin/ip route add $NET via $GW  metric 100 table $TABLE
done

exit 0
