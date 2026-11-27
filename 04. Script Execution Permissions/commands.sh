thor@jump-host ~$ ssh tony@stapp01
[tony@stapp01 ~]$  ls -l /tmp/xfusioncorp.sh
---------- 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ sudo chmod 777 /tmp/xfusioncorp.sh 
[sudo] password for tony: 
[tony@stapp01 ~]$ sudo chmod 777 /tmp/xfusioncorp.sh 
[tony@stapp01 ~]$  ls -l /tmp/xfusioncorp.sh
-rwxrwxrwx 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ exit
logout
Connection to stapp01 closed.
