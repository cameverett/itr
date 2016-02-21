#!/bin/bash

sourceRoot="/home"

showUsage()
{
	printf "Usage: class_collect -t <tag> -s </path/to/studentfile -c <class>\n";
}

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
		*) 
			printf "Invalid option was given\n"
			showUsage
			exit 1
			;;
	esac
done

if [ ! $instructor ] || [ ! $tag ] || [ ! $studentfile ] || [ ! $class ]; then
	if [ ! $instructor ]; then
		printf "Missing argument -i <instructor>\n"
	fi

	if [ ! $tag ]; then
		printf "Missing argument -t <searchtag>\n"
	fi

	if [ ! $studentfile ]; then
		printf "Missing argument -s </path/to/studentfile>\n"
	fi

	if [ ! $class ]; then
		printf "Missing argument -c <classname>\n"
	fi

	showUsage
	exit 1
fi

destination="$sourceRoot/$instructor/$class/homework"

if [ ! -d $destination ]; then
	printf "%s does not exist." "$destination"
	read -p "Would you like to create it? (y/n)" response
	case $response in 
		y )
			mkdir -p $destination
			;;
		n )
			showUsage
			exit 1
			;;
		* )
			showUsage
			exit 1
			;;
	esac
fi

while read student; do
	find $sourceRoot/$student/$class/submit -name $tag* -exec cp {} $destination \;
done < $studentfile
