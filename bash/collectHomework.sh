#!/bin/bash

sourceRoot="/home"
INSTRUCTOR_GROUP="instructors"

showUsage()
{
	printf "Usage: classman collect -t <tag> -s </path/to/studentfile\n";
}

while getopts ":i:t:s:" opt; do
	case $opt in
		i)
			instructor="$OPTARG"
			;;
		t)
			tag="$OPTARG"
			;;
		s)
			studentfile="$OPTARG"
			;;
		*)
			printf "Invalid option was given\n"
			showUsage
			exit 1
			;;
	esac
done

if [[ ! $instructor ]] || [[ ! $tag ]] || [[ ! -f $studentfile ]]; then
	if [[ ! $instructor ]]; then
		printf "Missing valid argument -i <instructor>\n"
	fi

	if [[ ! $tag ]]; then
		printf "Missing valid argument -t <searchtag>\n"
	fi

	if [[ ! -f $studentfile ]]; then
		printf "Missing valid argument -s </path/to/studentfile>\n"
	fi

	showUsage
	exit 1
fi

destination="$sourceRoot/$instructor/homework"

if [[ ! -d $destination ]]; then
	printf "Creating %s\n" "$destination"
	mkdir -p "$destination"
	chown -R "$instructor:$INSTRUCTOR_GROUP" "$destination"
	chmod -R 740 "$destination"
fi

touch "$destination/"$tag"log"
timeCollected=$(date +"%D %H:%M:%S")
#printf "Logged at: %s\n" "$timeCollected" >> "$destination/"$tag"log"
while read student; do
	if find "$sourceRoot/$student/submit/"*$tag* 1> /dev/null 2>&1; then
		mkdir -p "$destination/$student"
		cp -r "$sourceRoot/$student/submit/"*$tag* "$destination/$student"
	else
		#printf "%s\t%s\n" "$student" "$tag" >> "$destination/"$tag"log"
		sed -i -e '1i$student\t$tag\' "$destination/"$tag"log"
	fi
done < "$studentfile"
sed -i -e '1iLogged at: $timeCollected\' "$destination/"$tag"log"

chown -R "$instructor:$INSTRUCTOR_GROUP" "$destination"
chmod -R 740 "$destination"
