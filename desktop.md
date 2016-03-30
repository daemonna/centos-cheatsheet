

yum -y groups install "GNOME Desktop" 

systemctl set-default graphical.target 

> $ sudo systemctl get-default

> multi-user.target

And then change it to graphical:

$ sudo systemctl set-default
graphical.target

Targets

In Systemd the targets runlevel5.target and graphical.target are identical. So too are runlevel2.target and multi-user.target.

Runlevel    Target Units                          Description
0           runlevel0.target, poweroff.target     Shut down and power off the system.
1           runlevel1.target, rescue.target       Set up a rescue shell.
2           runlevel2.target, multi-user.target   Set up a non-graphical multi-user system.
3           runlevel3.target, multi-user.target   Set up a non-graphical multi-user system.
4           runlevel4.target, multi-user.target   Set up a non-graphical multi-user system.
5           runlevel5.target, graphical.target    Set up a graphical multi-user system.
6           runlevel6.target, reboot.target       Shut down and reboot the system.
