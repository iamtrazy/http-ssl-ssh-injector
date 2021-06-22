#!/bin/bash
ssh_ip=$(grep "host =" settings.ini | awk '{print $3}')
def_gate=$(ip r | grep 'default' | awk '{print$3}')
ip tuntap add dev tun0 mode tun user tun2sock
ip addr add 10.0.0.1/24 dev tun0
ip addr add fdfe:dcba:9876::1/125 dev tun0
ip route add $ssh_ip via $def_gate
ip link set tun0 up
ip -6 link set tun0 up
ip route add default dev tun0
ip -6 route add default dev tun0
dns2socks 127.0.0.1:1080 1.1.1.1:53 127.0.0.1:53 > /dev/null & sleep 5 &&  sed -i '1s/^/nameserver 127.0.0.1 /' /etc/resolv.conf && badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:7300
killall dns2socks
sed -i 's/nameserver 127.0.0.1 //'  /etc/resolv.conf
ip tuntap del dev tun0 mode tun
ip route del $ssh_ip via $def_gate
