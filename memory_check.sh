#!/bin/bash


while getopts ":w:c:e:" opts  #getting the parameters
do
	case "${opts}" in
	w)
		w=${OPTARG}
		;;

	c)
		c=${OPTARG}
		;;
						  
	e)
		e=${OPTARG}
		;;
	*)
		echo "Error! Required Parameters are -w(Warning) -c(Critical) -e(Email)"
		;;
	esac
done

TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }') #total memory
MEMORY=$( free | grep Mem: | awk ' { print $3 } ')    #memory used
Percentage=$(((100*MEMORY)/TOTAL_MEMORY))                    #percentage of the memory


if [ $w -ge $c ] #display error if the warning input is greater than the critical
then
	echo "Error! Critical threshold must be greater than Warning threshold. "
	echo "Required Parameters are -w(Warning) -c(Critical) -e(Email)"

fi

	shift $((OPTIND-1)) 

echo "Memory = $MEMORY"	      #print memory
echo "Total Memory = $TOTAL_MEMORY" #print total memory

if [ $Percentage -ge $c ] 
then
	echo "Used memory is greater than or equal to critical threshold." 
	exit 2
fi

if [ $Percentage -ge $w ]
then
	echo "Used memory is greater than or equal to warning threshold."
	exit 1
fi

if [ $Percentage -lt $w ] 
then
	echo "Used memory is less than warning threshold."
	exit 0
fi

