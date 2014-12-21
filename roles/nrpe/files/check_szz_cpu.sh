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
read -a old < /tmp/tmp_cpu.dat
cat /proc/stat|grep -i "cpu " > /tmp/tmp_cpu.dat
read -a new < /tmp/tmp_cpu.dat
user=$((new[1] - old[1]))
nice=$((new[2] - old[2))
sys=$((new[3] - old[3]))
idle=$((new[4] - old[4]))
iowait=$((new[5] - old[5]))
irq=$((new[6] - old[6]))
softirq=$((new[7] - old[7]))
overall=$((user + nice + sys + iowait + irq + softirq ))
sum=$((overall + idle))
user=$((100 * user / sum))
sys=$((100 * sys / sum))
overall=$((100 * overall / sum))
MSG="CPU OK - overall $overall%"
check_cond $overall $OVER_WARN 1 "CPU WARNING" "overall"
check_cond $overall $OVER_CRIT 2 "CPU CRITICAL" "overall"
check_cond $user $USER_WARN 1 "CPU WARNING" "user"
check_cond $user $USER_CRIT 2 "CPU CRITICAL" "user"
check_cond $iowait $IO_WARN 1 "CPU WARNING" "iowait"
check_cond $iowait $IO_CRIT 2 "CPU CRITICAL" "iowait"
PERF="'user'=$user%;$USER_WARN;$USER_CRIT;0; 'iowait'=$iowait%;$IO_WARN;$IO_CRIT;0; 'overall'=$overall%;$OVER_WARN;$OVER_CRIT;0; 'nice'=$nice%;100;100;0; 'irc'=$irq%;100;100;0; 'softirq'=$softirq%;100;100;0;"
echo $MSG "|"$PERF
exit $RESULT
