sourceRoot="/home"
destinationRoot="/home"
group="instructors"
permissions="770"

while getopts ":i:s:p:f:" opt; do
	case $opt in
	i ) instructor=$OPTARG ;;
	s ) studentfile=$OPTARG ;;
	p ) pathExtension=$OPTARG ;;
	f ) flag=$OPTARG ;;
	* ) printf "Usage classman return -s </path/to/studentfile> -i <your_username> -f <flag> -p </path/in/your/homework/directory\n"
	esac
done

if [[ ! $instructor ]] || [[ ! -f $studentfile ]]; then
	if [[ ! $instructor ]]; then
		printf "Missing Argument -i <instructor_username>\n"
	elif [[ ! -f $studentfile ]]; then
		printf "Missing Argument -s </path/to/studentfile>\n"
	elif [[ ! $flag ]]; then
		printf "Missing Argument -f <tag to search for assignment>\n"
	fi
	exit 1
fi	

pathRoot="$sourceRoot/$instructor/homework"
if [[ $pathExtension == "-f" ]]; then # TODO not sure why the p option defaults to "-f" when -p value not given.
	pathExtension=""
else
	pathExtension="$pathExtension/"
fi

while read student; do	
	if [[ ! -d "$pathRoot/$student/$pathExtension" ]]; then
		printf "%s/%s/%s/ does not exist.\n" "$pathRoot" "$student" "$pathExtension"
	else
		cp $pathRoot/$student/$pathExtension$flag* "$destinationRoot/$student/returned" 2> /dev/null
		sudo chown -R "$student:$group" "$destinationRoot/$student/returned"
		sudo chmod -R "$permissions" "$destinationRoot/$student/returned"
	fi
done < $studentfile

