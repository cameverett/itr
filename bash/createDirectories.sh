#!/bin/bash

sourceRoot="/home"
group="instructors"
permissions="777"

showUsage()
{
	printf "Usage: bash createDirectories.sh -c <classname> -s </path/to/studentfile>\n";
}

while getopts ":i:c:s:" opt; do
	case $opt in
		i )
			INSTRUCTOR_HOME_DIR="/home/$OPTARG"
			;;
		c ) 
			class=$OPTARG
			;;
		s ) 
			studentfile=$OPTARG
			;;
		* )
			showUsage
			exit 1
	esac
done

if [ ! $INSTRUCTOR_HOME_DIR ] || [ ! -f $studentfile ] || [ ! $class ]; then
			showUsage
			exit 1
fi

mkdir -p $INSTRUCTOR_HOME_DIR/$class/{submissions,mynotes,return}

while read student; do
	STUDENT_HOME_DIR="$sourceRoot/$student"
	mkdir -p $STUDENT_HOME_DIR/$class/{submit,returned,mynotes}
	#chown -R "$student:$group" $STUDENT_HOME_DIR/$class/{submit,returned,mynotes}
	chown -R "$student:$group" $STUDENT_HOME_DIR/$class 
	chmod -R $permissions $INSTRUCTOR_HOME_DIR/$class/{submit,returned,mynotes}
	#cp -r $INSTRUCTOR_HOME_DIR/$class $STUDENT_HOME_DIR/

	if \
	[ -d $STUDENT_HOME_DIR/$class/submit ] && \
	[ -d $STUDENT_HOME_DIR/$class/returned ] && \
	[ -d $STUDENT_HOME_DIR/$class/mynotes ];
	then
		printf "Directories created successfully for $student\n"
	else
		printf "Failed to create directories for $student\n"
	fi
done < $studentfile

