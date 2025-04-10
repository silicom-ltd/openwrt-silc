#!/bin/bash

INT_NAME=$1

if [ "$#" -ne 1 ] || [ "$1" = "help" ] || [ "$1" = "-h" ]; then
    echo "Usage: sh RF_test_setup.sh <interface_name>"
    exit 1
fi


echo "--------Switching RF driver--------"
echo "Uninstall mt7915e driver..."
rmmod mt7915e

echo "change the kernel debug print level"
echo 3 4 1 3 > /proc/sys/kernel/printk

echo "Loading mac80211 and mt_wifi drivers..." 
#modprobe mac80211

echo "set ip for interface $1 IP 192.168.11.1"
ifconfig $1 192.168.11.1

sleep 1
modprobe mt_wifi.ko

sleep 3
echo "Start ra0 and rax0 interfaces..." 
ifconfig ra0 up

sleep 20
ifconfig rax0 up

[[ $? == 0 ]] && echo "The rax interface started success!!"|| (echo "Please cold reboot the device before running the script!";exit 1)

#for i in `ip link|grep " UP "|awk -F: '{print $2}'`;do ated -b $i -i ra0 -u;done
ated -b $1 -i ra0 -u
[[ $? == 0 ]] && echo "ATED started success!!"||echo "ATED started failed!!"
