#!/bin/bash
sudo ip tuntap add dev tun0 mode tun user tun2sock
sudo ifconfig tun0 10.0.0.1 netmask 255.255.255.0
sudo ip addr add fdfe:dcba:9876::1 dev tun0
sudo route add 20.184.25.42 gw 192.168.43.1 metric 5
sudo route add default gw 10.0.0.2 metric 6
sudo ip -6 route add default dev tun0 metric 6
sudo badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:7300 --netif-ip6addr fdfe:dcba:9876::1
