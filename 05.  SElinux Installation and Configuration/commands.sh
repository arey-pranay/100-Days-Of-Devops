thor@jump-host ~$ ssh tony@stapp01
[tony@stapp01 ~]$ hostname
stapp01
[tony@stapp01 ~]$ whoami
tony
[tony@stapp01 ~]$ sudo yum install -y selinux-policy selinux-policy-targeted
[sudo] password for tony: 
[tony@stapp01 ~]$ /etc/selinux/config
-bash: /etc/selinux/config: Permission denied
[tony@stapp01 ~]$ sudo vi /etc/selinux/config
[tony@stapp01 ~]$ grep '^SELINUX=' /etc/selinux/config
SELINUX=disabled
[tony@stapp01 ~]$ 
