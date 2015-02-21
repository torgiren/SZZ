#!/bin/bash
if [ -z $1 ]
then
	echo "podaj dir"
	exit 1
fi
for i in `seq 0 8`
do
	c=$(echo 2^$i|bc)
	gnuplot << EOF
	set terminal png
	set output "${1}_${c}.png"
	set ylabel "Czas [ms]"
	set style data lines
	set xlabel "Procent zapytan"
	set datafile separator ","
	plot '$1/test_10.13.0.22_${c}.csv' u 1:2 every ::51 title 'Nginx', '$1/test_10.13.0.21_${c}.csv' u 1:2 every ::51 title 'Apache2'
EOF
done
