#!/bin/bash

showUsage () {
	printf "Usage: classman publish -s </path/to/studentfile> -a </path/to/assignment>\n"
}

while getopts ":s:a:" opt; do
	case $opt in
	s)
		studentfile="$OPTARG"
		;;
	a)
		assignment="$OPTARG"
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

if [[ -d $assignment ]]; then
	while read student; do
	mkdir -p "$destinationRoot/$student/published"
	cp -r "$assignment" "$destinationRoot/$student/published"
	chmod -R "$permissions" "$destinationRoot/$student/published"
	chown -R "$student":"$group" "$destinationRoot/$student/published"
	done < "$studentfile"
elif [[ -f $assignment ]]; then
	while read student; do
	mkdir -p "$destinationRoot/$student/published"
	cp "$assignment" "$destinationRoot/$student/published"
	chmod -R "$permissions" "$destinationRoot/$student/published"
	chown -R "$student":"$group" "$destinationRoot/$student/published"
	done < "$studentfile"
else
	printf "%s is not a file or directory\n" "$assignment"
	showUsage
	exit 1
fi
