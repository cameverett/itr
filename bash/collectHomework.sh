#!/bin/bash

sourceRoot="/home"

while getopts ":i:t:s:c:" opt; do
	case $opt in
		i) 
			instructor=$OPTARG
			;;
		t) 
			tag=$OPTARG
			;;
		s) 
			studentfile=$OPTARG
			;;
		c) 
			class=$OPTARG
			;;
	esac
done

destinationRoot="$sourceRoot/$instructor/homework"
#destinationRoot="$sourceRoot/$instructor/$class/homework"

cat "$studentfile" | \
while read student; do
	echo $student;
	#tree -f $sourceRoot/$student
done

