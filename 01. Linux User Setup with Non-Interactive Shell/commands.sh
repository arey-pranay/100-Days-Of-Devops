thor@jump-host ~$ ssh steve@stapp02
steve@stapp02s password: 
[steve@stapp02 ~]$ hostname
stapp02
[steve@stapp02 ~]$ whoami
steve
[steve@stapp02 ~]$ command -v nologin
/usr/sbin/nologin
[steve@stapp02 ~]$ sudo useradd -s /usr/sbin/nologin ammar

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[steve@stapp02 ~]$ sudo useradd -s /usr/sbin/nologin ammar
useradd: user 'ammar' already exists
[steve@stapp02 ~]$ id ammar
uid=1001(ammar) gid=1001(ammar) groups=1001(ammar)
[steve@stapp02 ~]$ exit
logout
Connection to stapp02 closed.
thor@jump-host ~$ 
