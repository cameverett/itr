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
		/?) 
			echo "Invalid option was given"
			;;
	esac
done

if [ ! $instructor ] || [ ! $tag ] || [ ! $studentfile ]; then
	if [ ! $instructor ]; then
		echo "Missing argument -i <instructor>"
	fi

	if [ ! $tag ]; then
		echo "Missing argument -t <searchtag>"
	fi

	if [ ! $studentfile ]; then
		echo "Missing argument -s <studentfile>"
	fi

	exit 1
fi

if [ $class ]; then
	destination="$sourceRoot/$instructor/$class/homework"
else
	destination="$sourceRoot/$instructor/homework"
fi

while [ ! -d $destination ]; do
	echo "$destination does not exist." 
	read -p "Would you like to create it or enter an existing one? (y/n)" response
	case $response in 
		y )
			mkdir -p $destination
			;;
		n )
			read -p "Enter your directory: " $destination
	esac
done

cat "$studentfile" | \
while read student; do
	find $sourceRoot/$student/submit -name $tag* -exec cp {} $destination \;
done

chgrp -R "$USER:instructors" $destination
