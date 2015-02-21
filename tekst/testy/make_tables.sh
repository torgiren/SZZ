#!/bin/bash
function czas {
	grep $4% $1/test_10.13.0.2${2}_$3.txt|awk '{print $2}'
}
if [ -z $1 ]
then
    echo "podaj dir"
    exit 1
fi
echo "\begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c||c|}"
echo "\hline"
echo "\multicolumn{2}{|c|}{}&\multicolumn{9}{|c||}{Procent obsłużonych zapytań}&Śr. czas\\\\"
echo "\hline"
echo "Równoległych& Server&50\%&66\%&75\%&80\%&90\%&95\%&98\%&99\%&100\%&\\\\"
echo "połączeń&WWW&&&&&&&&&&\\\\"
echo "\hline"
for i in `seq 0 8`
do
	echo "\hline"
	c=$(echo 2^$i|bc)
	echo "\multirow{2}{*}{$c}&Apache&$(czas $1 1 $c 50)&$(czas $1 1 $c 66)&$(czas $1 1 $c 75)&$(czas $1 1 $c 80)&$(czas $1 1 $c 90)&$(czas $1 1 $c 95)&$(czas $1 1 $c 98)&$(czas $1 1 $c 99)&$(czas $1 1 $c 100)&$(grep across $1/test_10.13.0.21_$c.txt|awk '{print $4}')\\\\"
	echo "\cline{2-12}"
	echo "&Nginx&$(czas $1 2 $c 50)&$(czas $1 2 $c 66)&$(czas $1 2 $c 75)&$(czas $1 2 $c 80)&$(czas $1 2 $c 90)&$(czas $1 2 $c 95)&$(czas $1 2 $c 98)&$(czas $1 2 $c 99)&$(czas $1 2 $c 100)&$(grep across $1/test_10.13.0.22_$c.txt|awk '{print $4}')\\\\"
	echo "\hline"
done

echo "\end{tabular}"
