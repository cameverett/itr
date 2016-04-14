sourceRoot="/home"
destinationRoot="/home"
group="instructors"
permissions="770"

while getopts ":i:s:p:f:" opt; do
	case $opt in
	i ) instructor=$OPTARG;;
	s ) studentfile=$OPTARG;;
	p ) path=$OPTARG;;
	f ) flag=$OPTARG;;
	* ) printf "Usage classman return -s </path/to/studentfile> -i <your_username> -f <flag> -p </path/in/your/homework/directory\n"
	esac
done
	
if [[ ! $instructor ]] || [[ ! -f $studentfile ]]; then
	if [ ! $instructor ]; then
		printf "Missing Argument -i <instructor_username>"
	elif [ ! $studentfile ]; then
		printf "Missing Argument -s </path/to/studentfile>\n"
	fi
	exit 1
fi	

if [ $path ]; then
	path="$sourceRoot/$instructor/homework/$path"
else
	path="$sourceRoot/$instructor/homework"
fi



if [ ! -d "$path/" ]; then
	printf "%s does not exist." "$path/"
	exit 1
fi

while read student; do	
	cp $path/$student/$flag* "$destinationRoot/$student/returned" 2> /dev/null
	chown -R "$student:$group" "$destinationRoot/$student/returned"
	chmod -R "$permissions" "$destinationRoot/$student/returned"
done < $studentfile

