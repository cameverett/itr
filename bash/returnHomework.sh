sourceRoot="/home"
destinationRoot="/home"
group="instructors"
permissions="770"

flag="_com";

while getopts ":i:s:p:f:" opt; do
	case $opt in
	i ) instructor=$OPTARG;;
	s ) studentfile=$OPTARG;;
	p ) path=$OPTARG;;
	f ) flag=$OPTARG;;
	* ) printf "Usage bash returnHomework.sh -s </path/to/studentfile> -i <your_username> -f <flag> -p </path/in/your/homework/directory\n"
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
	path="$sourceRoot/$instructor/homework/$path/"
else
	path="$sourceRoot/$instructor/homework/"
fi



if [ ! -d $path ]; then
	printf "%s does not exist." "$path"
	read -p "Would you like to create it? (y/n)" response
	case $response in
		y ) 
			mkdir -p $path
			;;

		n ) 
			showUsage
			exit 1
			;;

		* )
			showUsage
			exit 1
			;;

	esac

fi

while read student; do	
	#echo "$path$student"
	find "$path$student" -name *$flag* -exec cp -f {} "$destinationRoot/$student/returned" \;
done < $studentfile
