#!/bin/bash

INSTRUCTOR_GROUP="instructors"
sourceRoot="/home"

groupadd instructors

# $1 => text input file
# Create users and add to instructors group.
# Set password to their username appended with a 1.
setupInstructors()
{
	printf "Setting up instructor accounts\n"
	while read inputline; do
		DESTINATION_ROOT="$sourceRoot/$inputline"
		printf "$DESTINATION_ROOT $INSTRUCTOR_GROUP\n"
		useradd -g sudo -G $INSTRUCTOR_GROUP --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		chown -R "$inputline:$INSTRUCTOR_GROUP" $DESTINATION_ROOT
		chmod -R 740 $DESTINATION_ROOT
	done < $1
	printf "done reading instructor accounts: $1\n";
}

# $1 => text input file
# Create users with default groups and privileges
# Set password to their username appended with a 1.
setupStudents()
{
	printf "Setting up student accounts\n"
	printf "%s\n" "$1"
	while read inputline; do
		DESTINATION_ROOT="$sourceRoot/$inputline"
		printf "$DESTINATION_ROOT\n"
		useradd --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p $DESTINATION_ROOT/{submit,mynotes,returned}
		chown -R "$inputline:$INSTRUCTOR_GROUP" $DESTINATION_ROOT
		chmod -R 770 $DESTINATION_ROOT
	done < $1
	printf "done reading students: $1\n";
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
		* )
			printf "Usage: sudo </path/to/setup.sh> -i </path/to/instructorfile> -s </path/to/studentfile>"
			exit 1
	esac
done

if [[ ! -f $instructorfile ]]; then
	printf "\tError '$instructorfile' is not a file:\n\tUsage: -i path to instructors file\n"
	exit 1
else
	setupInstructors $instructorfile
fi

if [[ ! -f $studentfile ]]; then
	printf "\tError '$studentfile' is not a file:\n\tUsage: -s path to student file\n"
else
	setupStudents $studentfile
fi

# put man pages in /usr/share/man/man1
cp class_create.1.gz /usr/share/man/man1
cp class_collect.1.gz /usr/share/man/man1
