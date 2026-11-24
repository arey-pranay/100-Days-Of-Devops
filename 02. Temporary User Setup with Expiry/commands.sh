thor@jump-host ~$ ssh steve@stapp02
steve@stapp02s password: 
[steve@stapp02 ~]$ sudo useradd -e 2027-04-15 ravi

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[steve@stapp02 ~]$ id ravi
uid=1001(ravi) gid=1001(ravi) groups=1001(ravi)
[steve@stapp02 ~]$ sudo chage -l ravi
Last password change                                    : Nov 24, 2026
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : Apr 15, 2027
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
[steve@stapp02 ~]$ exit
logout
Connection to stapp02 closed.
