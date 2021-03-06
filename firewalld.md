# Firewall

## Enable forwarding

paste into /etc/sysctl.conf

net.ipv4.ip_forward=1

and activate this config with

sysctl -p /etc/sysctl.d/changes.conf

and add masquerade

firewall-cmd --set-default-zone=public

firewall-cmd --zone=public --add-masquerade

redirect ssh to other VMs

firewall-cmd --zone=external --add-forward-port=port=22:proto=tcp:toaddr=192.0.2.55

firewall-cmd --zone=external --add-forward-port=port=22:proto=tcp:toport=2055:toaddr=192.0.2.55

firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.100/25" service name="ssh" reject'

## Set ZONES

Reboot your gateway and after it comes back to life run the following command to see if zones were assigned correctly.

firewall-cmd --get-active-zones

Optional
Turn off ping
don't respond to a ping
net.ipv4.icmp_echo_ignore_all = 1

don't respond to a ping to the broadcast address
net.ipv4.icmp_echo_ignore_broadcasts = 1

disable IPv6 for all network interfaces
net.ipv6.conf.all.disable_ipv6 = 1

Rules
Script

```
#!/bin/bash

# firewall setup should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# check kernel forwarding is enabled
enabled=`cat /proc/sys/net/ipv4/ip_forward`
if [[ $enabled -ne 1 ]]; then
    echo "Kernel forwarding seems to be disabled, are internal and external zones assigned correctly?" 1>&2
    exit 1
fi
```

```
# we will have the following ports open on our gateway for all internal clients
#   22   - sshd for SSH
#   80   - http for HTTP traffic
#   443  - https for HTTPS traffic
#   3126 - for intercepted HTTP traffic for Squid
#   3127 - for intercepted HTTPS traffic for Squid
#   3128 - for normal explicit proxy traffic
#
firewall-cmd --zone=internal --add-service=ssh --permanent
firewall-cmd --zone=internal --add-service=http --permanent
firewall-cmd --zone=internal --add-service=https --permanent
firewall-cmd --zone=internal --add-port=3126/tcp --permanent
firewall-cmd --zone=internal --add-port=3127/tcp --permanent
firewall-cmd --zone=internal --add-port=3128/tcp --permanent
```
