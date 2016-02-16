#!/bin/bash
# Create environment for students and instructors.

INSTRUCTOR_GROUP="instructors"
sourceRoot="/home"

groupadd instructors

# $1 => text input file
setupInstructors()
{
	printf "Setting up instructor accounts\n"
	cat $1 | \
	while read inputline; do
		printf "$sourceRoot/$inputline $INSTRUCTOR_GROUP\n"
		useradd -g instructors --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p "$sourceRoot/$inputline/bin"
		cp bash/collectHomework.sh bash/createDirectories.sh $sourceRoot/$inputline/bin
		chown -R "$inputline:$INSTRUCTOR_GROUP" $sourceRoot/$inputline
		chmod -R 740 $sourceRoot/$inputline
	done
	printf "done reading $1\n";
}

# $1 => text input file
setupStudents()
{
	printf "Setting up student accounts\n"
	cat $1 | \
	while read inputline; do
		printf "$sourceRoot/$inputline\n"
		useradd --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p $sourceRoot/$inputline/{submit,mynotes,returned}
		chown -R "$inputline:$INSTRUCTOR_GROUP" $sourceRoot/$inputline
		chmod -R 770 $sourceRoot/$inputline
	done
	printf "done reading $1\n";
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
			printf "Usage: sudo bash setup.sh -i </path/to/instructorfile> -s </path/to/studentfile>"
			exit 1
			;;
	esac
done

if [[ ! -f $instructorfile ]]; then
	printf "\tError '$instructorfile' is not a file:\n\tUsage: -i path to instructors file\n"
else
	setupInstructors $instructorfile
fi

if [[ ! -f $studentfile ]]; then
	printf "\tError '$studentfile' is not a file:\n\tUsage: -s path to student file\n"
else
	setupStudents $studentfile
fi
