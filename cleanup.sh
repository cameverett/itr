#!/bin/bash

sourceRoot="/home"

while getopts ":i:s:" opt; do
	case $opt in
		i )
			instructorfile=$OPTARG
			;;
		s )
			studentfile=$OPTARG
			;;
		/? )
			printf "Usage sudo /path/to/cleanup.sh -i </path/to/instructorfile> -s </path/to/studentfile>"
			;;
	esac
done

if [[ ! -f $instructorfile ]]; then
	printf "\tError '$instructorfile' not a file:\n\tUsage: -i path to instructors file\n"
else
	
	while read instructor; do
		userdel $instructor -r -f
	done < $instructorfile
fi

if [[ ! -f $studentfile ]]; then
	printf "\tError '$studentfile' not a file:\n\tUsage: -s path to student file\n"
else
	
	while read student; do
		userdel	$student -r -f
	done < $studentfile
fi

groupdel instructors
