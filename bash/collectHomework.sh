#!/bin/bash

sourceRoot="/home"
INSTRUCTOR_GROUP="instructors"

showUsage()
{
	printf "Usage: class_collect -i <your_username> -t <tag> -s </path/to/studentfile\n";
}

while getopts ":i:t:s:" opt; do
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
		*) 
			printf "Invalid option was given\n"
			showUsage
			exit 1
			;;
	esac
done

if [ ! $instructor ] || [ ! $tag ] || [ ! $studentfile ]; then
	if [ ! $instructor ]; then
		printf "Missing argument -i <instructor>\n"
	fi

	if [ ! $tag ]; then
		printf "Missing argument -t <searchtag>\n"
	fi

	if [ ! $studentfile ]; then
		printf "Missing argument -s </path/to/studentfile>\n"
	fi

	showUsage
	exit 1
fi

destination="$sourceRoot/$instructor/homework"

if [ ! -d $destination ]; then
	printf "Creating %s\n" "$destination"
	mkdir -p $destination
fi

touch "$destination/log.tsv"
while read student; do
	if ls -U $sourceRoot/$student/submit/$tag* 1> /dev/null 2>&1; then
		mkdir -p $destination/$student
		cp $sourceRoot/$student/submit/$tag* $destination/$student
	else
		printf "%s\t%s\n" "$student" "$tag" >> "$sourceRoot/$instructor/homework/log.tsv"
	fi
done < $studentfile

chown -R "$instructor:$group" $destination
chmod -R 740 $destination
