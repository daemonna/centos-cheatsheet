# Install MLS

```
yum install selinux-policy-mls policycoreutils­python
```

set policy to permissive in /etc/selinux/config

```
SELINUX=permissive

SELINUXTYPE=mls
```

Create the .autorelabel file in root's home directory to ensure that files are relabeled upon next reboot

```
touch /.autorelabel
```
| Searching For  | Command |
| ------------- | ------------- |
| all denials  | ausearch -m avc  |
| denials for that today  | ausearch -m avc -ts today  |
| denials from the last 10 minutes  | ausearch -m avc -ts recent  |

If there were no denial messages in **/var/log/messages** (or using `ausearch -m avc`), or you have resolved all existing denials, configure SELINUX=enforcing in the /etc/selinux/config file

```
SELINUX=enforcing
```

Reboot your system and make sure SELinux is running in permissive mode

```
getenforce
```

and the MLS policy is enabled

```
sestatus |grep mls
```
