#!/bin/bash
virsh="virsh -c qemu+ssh://torgiren@10.13.0.1/system"
if [ "$1" == "start" ]
then
	cmd="start"
elif [ "$1" == "shutdown" ]
then
	cmd="shutdown"
else
	cmd="brak polecenia"
	exit
fi
for i in `$virsh list --all|egrep 'mgr[0-9][0-9]*'|awk '{print $2}'|grep -v '^mgr0$'`;
do
	echo $i
	$virsh $cmd $i
done
