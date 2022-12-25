#!/bin/bash

# Assign an IP address to local loopback 
ip addr add 127.0.0.1/32 dev lo
ip link set dev lo up
touch /app/libnsm.so

socat VSOCK-LISTEN:22,reuseaddr,fork TCP:localhost:22 &
service ssh start

python3 /app/server.py server 5005