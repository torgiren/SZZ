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
	plot '$1/test_10.13.0.11_${c}.csv' u 1:2 every ::51::100 title 'Nginx', '$1/test_10.13.0.101_${c}.csv' u 1:2 every ::51::100 title 'LVS 2xRS', '$1/test_10.13.0.102_${c}.csv' u 1:2 every ::51::100 title 'LVS 3xRS', '$1/test_10.13.0.103_${c}.csv' u 1:2 every ::51::100 title 'LVS 4xRS'
EOF
done
