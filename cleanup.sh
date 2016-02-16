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
			printf "Usage sudo bash cleanup.sh -i </path/to/instructorfile> -s </path/to/studentfile>"
			;;
	esac
done

if [[ ! -f $instructorfile ]]; then
	printf "\tError '$instructorfile' not a file:\n\tUsage: -i path to instructors file\n"
else
	cat $instructorfile | \
	while read inputline; do
		userdel $inputline -r -f
	done
fi

if [[ ! -f $studentfile ]]; then
	printf "\tError '$studentfile' not a file:\n\tUsage: -s path to student file\n"
else
	cat $studentfile | \
	while read inputline; do
		userdel	$inputline -r -f
	done
fi

groupdel instructors