#!/bin/bash

sourceRoot="/home"
group="instructors"
permissions="770"

while getopts ":c:s:" opt; do
	case $opt in
		c) 
			class=$OPTARG
			;;
		s) 
			studentfile=$OPTARG
			;;
		/?)
			echo "Usage: bash createDirectories.sh -c <classname> -s <studentfile>"
	esac
done

while [ ! -e $studentfile ]; do
	read -p "Enter path to student list: " studentfile
done

cat "$studentfile" | \
while read student; do
	mkdir -p $sourceRoot/$student/{submit,returned,mynotes}
	chown -R "$student:$group" $sourceRoot/$student/{submit,returned,mynotes}
	chown "$student:$group" $sourceRoot/$student
	chmod $permissions $sourceRoot/$student/{submit,returned,mynotes}

	if \
	[ -d $sourceRoot/$student/submit ] && \
	[ -d $sourceRoot/$student/returned ] && \
	[ -d $sourceRoot/$student/mynotes ];
	then
		echo "Directories created successfully for $student"
	else
		>&2 echo "Failed to create directories for $student"
	fi
done

