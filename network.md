How do I disable IPv6?

Upstream employee Daniel Walsh recommends not disabling the ipv6 module, as that can cause issues with SELinux and other components, but adding the following to /etc/sysctl.conf:

> net.ipv6.conf.all.disable_ipv6 = 1

> net.ipv6.conf.default.disable_ipv6 = 1

To disable in the running system:

> echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

> echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6

or

> sysctl -w net.ipv6.conf.all.disable_ipv6=1

> sysctl -w net.ipv6.conf.default.disable_ipv6=1
