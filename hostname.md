To set hostname execute

```
hostnamectl set-hostname Your-New-Host-Name-Here
hostnamectl set-hostname "Your New Host Name Here" --pretty
hostnamectl set-hostname Your-New-Host-Name-Here --static
hostnamectl set-hostname Your-New-Host-Name-Here --transient
```

so for example

```
hostnamectl set-hostname  "myredmine.xyz.bigcorp.net" --static
systemctl restart systemd-hostnamed 
```
