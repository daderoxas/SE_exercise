#!/bin/bash


while getopts ":w:c:e:" opts  #getopts to get the parameters
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
	/?)
		echo "Error! Required Parameters are -w(Warning) -c(Critical) -e(Email)"
		;;
	esac
done

TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }') #getting the total memory
MEMORY=$( free | grep Mem: | awk ' { print $3 } ')    #getting the memory occupied
Percentage=$(((100*MEMORY)/TOTAL_MEMORY))                    #getting memory%


if [ $w -ge $c ] #print error if warning% is greater than or equal to critical%
then
	echo "Error! Critical threshold must be greater than Warning threshold. "
	echo "Required Parameters are -w(Warning) -c(Critical) -e(Email)"

fi

	shift $((OPTIND-1)) 

echo "Memory = $MEMORY"	      #print memory
echo "Total Memory = $TOTAL_MEMORY" #print total memory

if [ $Percentage -ge $c ] #if mem% greater than or equal to critical%
then
	echo "Used memory is greater than or equal to critical threshold." 
	exit 2
fi

if [ $Percentage -ge $w ] #if mem% is greater than or equal to warning%
then
	echo "Used memory is greater than or equal to warning threshold."
	exit 1
fi

if [ $Percentage -lt $w ] #if mem% is less than %warning%
then
	echo "Used memory is less than warning threshold."
	exit 0
fi

