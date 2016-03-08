#!/bin/bash
# Create environment for students and instructors.

INSTRUCTOR_GROUP="instructors"
sourceRoot="/home"

groupadd instructors

# $1 => text input file
setupInstructors()
{
	printf "Setting up instructor accounts\n"
	while read inputline; do
		DESTINATION_ROOT="$sourceRoot/$inputline"
		COLLECT_ALIAS="alias class_create=\"sudo bash $DESTINATION_ROOT/bin/bash/createDirectories.sh\""
		CREATE_ALIAS="alias class_collect=\"sudo bash $DESTINATION_ROOT/bin/bash/collectHomework.sh\""
		RETURN_ALIAS="alias class_return=\"sudo bash $DESTINATION_ROOT/bin/bash/returnHomework.sh\""
		printf "$DESTINATION_ROOT $INSTRUCTOR_GROUP\n"
		useradd -g sudo -G $INSTRUCTOR_GROUP --create-home $inputline
		printf "%s:%s1" "$inputline" "$inputline" | chpasswd
		mkdir -p "$DESTINATION_ROOT/bin"
		cp -r "bash/" "$DESTINATION_ROOT/bin"
		touch $DESTINATION_ROOT/.bash_aliases
		printf "%s\n%s\n%s" "$COLLECT_ALIAS" "$CREATE_ALIAS" "$RETURN_ALIAS" >> $DESTINATION_ROOT/.bash_aliases
		chown -R "$inputline:$INSTRUCTOR_GROUP" $DESTINATION_ROOT
		chmod -R 740 $DESTINATION_ROOT
	done < $1
	printf "done reading instructor accounts: $1\n";
}

# $1 => text input file
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
			printf "Usage: sudo /path/to/setup.sh -i </path/to/instructorfile> -s </path/to/studentfile>"
			exit 1
			;;
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

