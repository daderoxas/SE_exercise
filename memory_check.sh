#!/bin/bash

usage() { echo "Required Parameters are -w(Warning) -c(Critical) -e(Email)"; exit 3; }

if [ $# -eq 0 ] #if no parameters were supplied will show the needed parameters
then
	usage
fi

while getopts ":w:c:e:" opt;  #getting the arguments of the parameters
do
	case "${opt}" in
	w)
		w=${OPTARG}
		;;

	c)
		c=${OPTARG}
		;;
						  
	e)
		e=${OPTARG}
		;;
	
	 :)
      		echo "Option -$OPTARG requires an argument." >&2
      		exit 3
      		;;
	 \?) 	echo "Invalid option: -$OPTARG" >&2
		echo "Required Parameters are -w(Warning) -c(Critical) -e(Email)"
		exit 3
		;;

	*)
		usage
		
		;;

	esac
done

shift $((OPTIND-1))


TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }') #total memory
MEMORY=$( free | grep Mem: | awk ' { print $3 } ')    #memory used
Percentage=$(((100*MEMORY)/TOTAL_MEMORY))                    #percentage of the memory used

if [ "${w}" -ge "${c}" ] #will be shown if warning is greater than critical
then
	echo "Error! Critical threshold must be greater than Warning threshold. "
	exit 3

fi

used_mem() {
echo "Used Memory = $MEMORY"       #print memory
echo "Total Memory = $TOTAL_MEMORY" #print total memory

}

datetime="$(date +'%Y%m%d %H:%M')" #date and time

if [ $Percentage -ge "${c}" ] #if memory used is greater than or equal to critical
then
	LINES=17 top -n 1 -o %MEM > topten.txt #top ten processes
	mailx -a topten.txt -s "$datetime memory check -critical" "${e}" #sends mail
	echo "Critical! Used memory is greater than or equal to critical threshold." 
	used_mem

	echo "Memory used: $Percentage %"
	exit 2

fi

if [ $Percentage -ge "${w}" ] #if memory used is greater than or equal to warning
then
	echo "Warning! Used memory is greater than or equal to warning threshold."
	used_mem
	
	echo "Memory used: $Percentage %"
	exit 1
fi

if [ $Percentage -lt "${w}" ] #if if memory used is less than warning
then
	echo "Used memory is less than warning threshold."
	used_mem

	echo "Memory used: $Percentage %"
	exit 0
fi

