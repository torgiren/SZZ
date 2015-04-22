#!/bin/bash
if [ -z $1 ]
then
    echo "podaj dir"
    exit 1
fi
mkdir $1
for s in {10.13.0.11,10.13.0.101,10.13.0.102,10.13.0.103}
do
    for i in {0..8}
    do
		conc=$(echo "2^$i"|bc)
		echo $s $conc
		ab -k -r -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/small.html > ./$1/test_${s}_${conc}.txt
		#/tmp/httpd-2.4.12/support/ab -k -r -l -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/small.html > ./$1/test_${s}_${conc}.txt
	#	ab  -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/index.html > ./$1/test_${s}_${conc}.txt
    done
done
