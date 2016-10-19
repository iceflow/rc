#!/bin/bash



REMOUTE_NETS="8.8.8.8/32 23.239.1.72/32 118.184.180.46/32 52.71.51.30/32"

# Google
REMOUTE_NETS="${REMOUTE_NETS} 172.0.0.0/8 173.0.0.0/8 216.0.0.0/8 74.0.0.0/8 209.0.0.0/8"

GW=10.8.0.1


for NET in ${REMOUTE_NETS}; do
	/sbin/ip route add $NET via 10.8.0.1 metric 100
done

