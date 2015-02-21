#!/bin/bash
if [ -z $1 ]
then
    echo "podaj dir"
    exit 1
fi
mkdir $1
for s in {10.13.0.21,10.13.0.22}
do
    for i in {0..8}
    do
	conc=$(echo "2^$i"|bc)
	echo $s $conc
	/tmp/httpd-2.4.12/support/ab  -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/fib.php > ./$1/test_${s}_${conc}.txt
#	ab  -n10000 -c $conc -e ./$1/test_${s}_${conc}.csv http://$s/index.html > ./$1/test_${s}_${conc}.txt
    done

done
