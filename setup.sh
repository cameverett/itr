#!/bin/bash
# Create environment for students and instructors.

INSTRUCTOR_GROUP="instructors"
sourceRoot="/home"

groupadd instructors

# $1 => text input file
# $2 => directory to exported instructor scripts
setupInstructors()
{
	printf "Setting up instructor accounts\n"
	cat $1 | \
	while read inputline; do
		printf "$sourceRoot/$inputline $INSTRUCTOR_GROUP\n"
		useradd -g instructors --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p "$sourceRoot/$inputline/bin"
		cp $2/*.sh $sourceRoot/$inputline/bin
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

while getopts ":r:i:s:p:" opt; do
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
		p ) # path to directory containing bash scripts for instructors
			instructor_scripts=$OPTARG
			;;
		/? )
			printf "Usage: sudo /path/to/setup.sh -i </path/to/instructorfile> -s </path/to/studentfile>"
			exit 1
			;;
	esac
done

if [[ ! -f $instructorfile ]]; then
	printf "\tError '$instructorfile' is not a file:\n\tUsage: -i path to instructors file\n"
elif [[ ! -d $instructor_scripts ]]; then
	printf "\tError '$instructor_scripts' is not a directory:\n\tUsage: -p path to folder containing instructor scripts\n"
else
	setupInstructors $instructorfile $instructor_scripts
fi

if [[ ! -f $studentfile ]]; then
	printf "\tError '$studentfile' is not a file:\n\tUsage: -s path to student file\n"
else
	setupStudents $studentfile
fi
