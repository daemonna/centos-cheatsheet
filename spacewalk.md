install epel

```
yum install epel-release
```

install additional JPackage repo

```
cat > /etc/yum.repos.d/jpackage-generic.repo << EOF
[jpackage-generic]
name=JPackage generic
#baseurl=http://mirrors.dotsrc.org/pub/jpackage/5.0/generic/free/
mirrorlist=http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=5.0
enabled=1
gpgcheck=1
gpgkey=http://www.jpackage.org/jpackage.asc
EOF
```

install Spacewalk repo

```
rpm -Uvh http://yum.spacewalkproject.org/2.3/RHEL/7/x86_64/spacewalk-repo-2.3-4.el7.noarch.rpm
yum install spacewalk-setup-postgresql
yum install spacewalk-postgresql
```

configure firewall

The following inbound TCP ports should be open on the Spacewalk server:
```
69: TFTP (PXE provisioning)
80: Spacewalk web interface
443: Spacewalk web interface (SSL)
4545: Spacewalk monitoring
5222: If you plan to push actions to client systems
5269: If you push actions to a Spacewalk Proxy Server
9055: Oracle XE web access
```

```
firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```



Well, run the following command to configure the Spacewalk server:

```
spacewalk-setup --disconnected
```

You can also configure Spacewalk by using an answer file, by running spacewalk-setup like

```
spacewalk-setup --disconnected --answer-file=<FILENAME>
```

An example answer file for the pg database backend:

```
admin-email = root@localhost
ssl-set-org = SOME corp
ssl-set-org-unit = spacewalk
ssl-set-city = Bratislava
ssl-set-state = Slovakia
ssl-set-country = SK
ssl-password = spacewalk
ssl-set-email = root@localhost
ssl-config-sslvhost = Y
db-backend=postgresql
db-name=spaceschema
db-user=spaceuser
db-password=spacepw
db-host=localhost
db-port=5432
enable-tftp=Y
```

Spacewalk consists of several services. Each of them has its own init.d script to stop/start/restart. If you want manage all spacewalk services at once use

```
/usr/sbin/spacewalk-service [stop|start|restart]
```
