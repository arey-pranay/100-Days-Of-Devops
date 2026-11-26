thor@jump-host ~$ ssh tony@stapp01
The authenticity of host 'stapp01 (10.244.97.157)' can't be established.
ED25519 key fingerprint is SHA256:3d+QQLtNdC1mulJ8vaLJeXlioRNGYXVg8laeTEhZZeA.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp01' (ED25519) to the list of known hosts.
tony@stapp01's password: 
Permission denied, please try again.
tony@stapp01's password: 
Last failed login: Thu Nov 26 14:55:58 UTC 2026 from 10.244.195.9 on ssh:notty
There was 1 failed login attempt since the last successful login.
[tony@stapp01 ~]$ sudo vi /etc/ssh/sshd_config

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
[tony@stapp01 ~]$ sudo systemctl restart sshd
[tony@stapp01 ~]$ sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[tony@stapp01 ~]$ exit
logout
Connection to stapp01 closed.
thor@jump-host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (10.244.234.217)' can't be established.
ED25519 key fingerprint is SHA256:Zo5CD3U/nRHjrDiApk+1XOQPM8Z1xJDUtXeXX6Wd2tw.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp02' (ED25519) to the list of known hosts.
steve@stapp02's password: 
[steve@stapp02 ~]$ sudo vi /etc/ssh/sshd_config

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[steve@stapp02 ~]$ sudo systemctl restart sshd
[steve@stapp02 ~]$ sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[steve@stapp02 ~]$ sudo systemctl restart sshd
[steve@stapp02 ~]$ sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[steve@stapp02 ~]$ exit
logout
Connection to stapp02 closed.
thor@jump-host ~$ ssh banner@stapp03
The authenticity of host 'stapp03 (10.244.49.14)' can't be established.
ED25519 key fingerprint is SHA256:Bh/7S+SiUUWCYkFbk1vulyxQMHr0BTr89l0h4Cwy6nI.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp03' (ED25519) to the list of known hosts.
banner@stapp03's password: 
[banner@stapp03 ~]$ sudo vi /etc/ssh/sshd_config

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
[banner@stapp03 ~]$  sudo systemctl restart sshd
[banner@stapp03 ~]$  sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[banner@stapp03 ~]$ exit
logout
Connection to stapp03 closed.
thor@jump-host ~$ 
