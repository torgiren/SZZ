#!/bin/bash
if [ -z $1 ]
then
    echo "podaj dir"
    exit 1
fi
mkdir $1
for s in {10.13.0.110,10.13.0.111,10.13.0.112,10.13.0.113}
do
    for i in {0..8}
    do
		conc=$(echo "2^$i"|bc)
		echo $s $conc
		ab -k -r -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/small.html > ./$1/test_${s}_${conc}.txt
		#/tmp/httpd-2.4.12/support/ab -k -r -l -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/small.html > ./$1/test_${s}_${conc}.txt
	#	ab  -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/index.html > ./$1/test_${s}_${conc}.txt
    done
	echo "zrobilem $s"
	read
done
