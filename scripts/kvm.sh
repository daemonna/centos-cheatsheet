#!/bin/bash

grep -e 'vmx' /proc/cpuinfo


virt-install --name Cent1 --ram 512 --disk path=/tmp/winxp.img,size=6 --network network:default --vnc --os-variant centos --cdrom /dev/sr0

virt-viewer --connect qemu_ssh://myhost/$Name
