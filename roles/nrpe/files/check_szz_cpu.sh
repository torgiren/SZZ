#!/bin/bash
####
# Plugin to measure CPU usage.
# by Marcin Fabrykowski
####
USER_WARN=100
USER_CRIT=100
OVER_WARN=100
OVER_CRIT=100
IO_WARN=100
IO_CRIT=100
RESULT=0
MSG="CPU OK"
function help {
	echo -e "Usage:\n$0 [-o warn] [-O crit] [-u warn] [-U crit] [-i warn] [-I crit]"
	echo -e "$0 -h"
	echo 
    echo -e " -o\n    warning level of overall CPU usage"
    echo -e " -O\n    critical level of overall CPU usage"
    echo -e " -u\n    warning level of user CPU usage"
    echo -e " -U\n    critical level of user CPU usage"
    echo -e " -i\n    warning level of iowait CPU usage"
    echo -e " -I\n    critical level of iowait CPU usage"
    echo -e " -h\n    help"
}
function check_cond {
	if [ $(echo "$1 > $2"|bc -l) -eq 1 ]
	then
		if [ $RESULT -lt $3 ]
		then
			RESULT=$3
			MSG="$4 - $5 $1%"
		fi
	fi
}
while getopts o:O:u:U:i:I:h option
do
	case "${option}" in
		h) 
			help;;
		o)
			OVER_WARN=${OPTARG};;
		O)
			OVER_CRIT=${OPTARG};;
		u)
			USER_WARN=${OPTARG};;
		U)
			USER_CRIT=${OPTARG};;
		i)
			IO_WARN=${OPTARG};;
		I)
			IO_CRIT=${OPTARG};;
					
		esac
done
stats=$(iostat -c -y 1 1|grep cpu -A1|tail -n1|tr ',' '.')
user=$(echo $stats|awk '{print $1}')
nice=$(echo $stats|awk '{print $2}')
sys=$(echo $stats|awk '{print $3}')
iowait=$(echo $stats|awk '{print $4}')
steal=$(echo $stats|awk '{print $5}')
idle=$(echo $stats|awk '{print $6}')
overall=$(echo $stats|awk '{print $1+$2+$3+$4+$5}')
check_cond $overall $OVER_WARN 1 "CPU WARNING" "overall"
check_cond $overall $OVER_CRIT 2 "CPU CRITICAL" "overall"
check_cond $user $USER_WARN 1 "CPU WARNING" "user"
check_cond $user $USER_CRIT 2 "CPU CRITICAL" "user"
check_cond $iowait $IO_WARN 1 "CPU WARNING" "iowait"
check_cond $iowait $IO_CRIT 2 "CPU CRITICAL" "iowait"
PERF="user=$user%;$USER_WARN;$USER_CRIT;0; 'iowait'=$iowait%;$IO_WARN;$IO_CRIT;0; 'overall'=$overall%;$OVER_WARN;$OVER_CRIT;0;"
echo $MSG "|"$PERF
exit $RESULT
