#!/bin/bash

showUsage () {
	printf "Usage: classman assign -s </path/to/studentfile> -a </path/to/assignment>\n"
}

while getopts ":s:f:d:" opt; do
	case $opt in
	s)
		studentfile=$OPTARG
		;;
	a)
		assignment=$OPTARG
		;;
	*)
		showUsage
		exit 1
	esac
done

sourceRoot="/home"
destinationRoot="/home"
group="instructors"
permissions="770"

if [[ -f $studentfile ]]; then
	printf "%s was not found or is not a file." "$studentfile"
	showUsage
	exit 1
fi

if [[ -d $assignment ]]; then
	while read student; do
	mkdir -p "$destinationRoot/$student/assignments"
	cp -r $assignment "$destinationRoot/$student/assignments"
	chmod "$permissions" "$destinationRoot/$student/assignments"
	chown "$student":"$group" "$destinationRoot/$student/assignments"
	done < $studentfile
elif [[ -f $assignment ]]; then
	while read student; do
	mkdir -p "$destinationRoot/$student/assignments"
	cp $assignment "$destinationRoot/$student/assignments"
	chmod "$permissions" "$destinationRoot/$student/assignments"
	chown "$student":"$group" "$destinationRoot/$student/assignments"
	done < $studentfile
else
	printf "%s is not a file or directory\n" "$assignment"
	showUsage
	exit 1
fi
