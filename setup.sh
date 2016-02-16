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
		r )
			root=$OPTARG
			;;
		i )
			instructorfile=$OPTARG
			;;
		s )
			studentfile=$OPTARG
			;;
		/? )
			exit 1
			;;
	esac
done

echo "Setting up instructor accounts"
if [[ ! $instructorfile ]] || [[ ! -f $instructorfile ]]; then
	echo "-i you goofed"
else
	setupInstructors $instructorfile
fi

echo "Setting up student accounts"
if [[ ! $studentfile ]] || [[ ! -f $studentfile ]]; then
	echo "-s you goofed"
else
	setupStudents $studentfile
fi

tree /home
