#!/bin/bash


ip route add default via 172.25.1.1 table 5
#ip route add 172.25.2.0/24 via 172.25.1.1 table 5
bird -c /etc/bird/bird.conf -f
