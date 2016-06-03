sourceRoot="/home"
destinationRoot="/home"
group="instructors"
permissions="770"

while getopts ":i:s:f:p:" opt; do
	case $opt in
	i ) instructor="$OPTARG" ;;
	s ) studentfile="$OPTARG" ;;
	p ) pathExtension="$OPTARG" ;;
	f ) flag="$OPTARG" ;;
	* ) printf "Usage classman return -s </path/to/studentfile> -i <your_username> -f <flag> -p </path/in/your/homework/directory\n"
	esac
done

echo "-p $pathExtension"

if [[ -z $instructor ]] || [[ ! -f "$studentfile" ]] || [[ -z $flag ]]; then
	if [[ -z $instructor ]]; then
		printf "Missing Argument -i <instructor_username>\n"
	elif [[ ! -f "$studentfile" ]]; then
		printf "Missing Argument -s </path/to/studentfile>\n"
	elif [[ -z $flag ]]; then
		printf "Missing Argument -f <tag to search for assignment>\n"
	fi
	exit 1
fi

pathRoot="$sourceRoot/$instructor/homework"
#if [[ -z $pathExtension ]];
	#pathExtension=""
#else
	#pathExtension="$pathExtension/"
#fi

while read student; do
	#if [[ ! -d "$pathRoot/$student/$pathExtension" ]]; then
		#printf "%s/%s/%s/ does not exist.\n" "$pathRoot" "$student" "$pathExtension"
	#else
		#cp "$pathRoot/$student/$pathExtension"*$flag* "$destinationRoot/$student/returned" 2> /dev/null
		#cp "$pathRoot/$student/"*$flag* "$destinationRoot/$student/returned" 2> /dev/null
		find "$pathRoot/$student" -iname "*$flag*" -exec cp {} "$destinationRoot/$student/returned" \;
		sudo chown -R "$student:$group" "$destinationRoot/$student/returned"
		sudo chmod -R "$permissions" "$destinationRoot/$student/returned"
	#fi
done < "$studentfile"
