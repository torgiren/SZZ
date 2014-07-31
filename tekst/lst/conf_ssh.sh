admin@master:~$ ssh admin@conf
admin's password: 
admin@conf:~$ vim /etc/http/vhosts.conf/test.pl.conf
admin@conf:~$ apachectl -t
Syntax OK
admin@conf:~$ apachectl graceful
admin@conf:~$ exit
