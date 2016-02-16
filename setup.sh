#!/bin/bash
# Create environment for students and instructors.

INSTRUCTOR_GROUP="instructors"
sourceRoot="/home"

groupadd instructors

# $1 => text input file
setupInstructors()
{
	cat $1 | \
	while read inputline; do
		printf "$sourceRoot/$inputline $INSTRUCTOR_GROUP  "
		useradd -g instructors --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		chown -R "$inputline:$INSTRUCTOR_GROUP" $sourceRoot/$inputline
		chmod -R 740 $sourceRoot/$inputline
	done
	printf "done reading $1\n\n";
}

# $1 => text input file
setupStudents()
{
	cat $1 | \
	while read inputline; do
		printf "$sourceRoot/$inputline\n"
		useradd --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p $sourceRoot/$inputline/{submit,mynotes,returned}
		chown -R "$inputline:$INSTRUCTOR_GROUP" $sourceRoot/$inputline
		chmod -R 770 $sourceRoot/$inputline
	done
	printf "done reading $1";
}

while getopts ":r:i:s:" opt; do
	case $opt in
		r ) # Select different root for users
			sourceRoot=$OPTARG
			;;
		i ) # path to file containing usernames for instructors
			instructorfile=$OPTARG
			;;
		s ) # path to file containing usernames for students
			studentfile=$OPTARG
			;;
		/? )
			exit 1
			;;
	esac
done

printf "Setting up instructor accounts"
if [[ ! $instructorfile ]] || [[ ! -f $instructorfile ]]; then
	printf "Usage: -i path to instructors file"
	exit 1
else
	setupInstructors $instructorfile
fi

printf "Setting up student accounts"
if [[ ! $studentfile ]] || [[ ! -f $studentfile ]]; then
	printf "Usage: -s path to student file"
	exit 1
else
	setupStudents $studentfile
fi
