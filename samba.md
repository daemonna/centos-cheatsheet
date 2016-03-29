> setsebool -P samba_export_all_ro=1 samba_export_all_rw=1

> getsebool –a | grep samba_export

> semanage fcontext –at samba_share_t "/finance(/.*)?"

> restorecon /finance

In addition, we must ensure that Samba traffic is allowed by the firewalld.

> firewall-cmd --permanent --add-service=samba

> firewall-cmd --reload
