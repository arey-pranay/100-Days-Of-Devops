ssh tony@stapp01
[tony@stapp01 ~]$ hostname
stapp01
[tony@stapp01 ~]$ whoami
tony
sudo grep -in 'PermitRootLogin' /etc/ssh/sshd_config
[sudo] password for tony: 
40:#PermitRootLogin prohibit-password
90:# the setting of "PermitRootLogin without-password".
131:PermitRootLogin yes
[tony@stapp01 ~]$ sudo vi /etc/ssh/sshd_config
[tony@stapp01 ~]$ sudo sshd -t
[sudo] password for tony: 
[tony@stapp01 ~]$ sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[tony@stapp01 ~]$ sudo systemctl reload sshd
