Single cockpit instance

Install cockpit

```
yum install cockpit cockpit-ws cockpit-selinux-policy

semanage port -a -t websm_port_t -p tcp 9999

systemctl enable cockpit.socket

firewall-cmd --permanent --zone=public --add-service=cockpit

firewall-cmd --reload

systemctl daemon-reload

systemctl restart cockpit
```

Login to cockpit

go to localhost:9090
