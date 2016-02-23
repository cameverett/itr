sourceRoot="/home"
group="instructors"
permissions="770"

while getopts ":i:s:c:t:" opt; do
	case $opt in
	i ) instructor=$OPTARG;;
	s ) studentfile=$OPTARG;;
	c ) class=$OPTARG;;
	t ) tag=$OPTARG;;
	\?) printf "Usage......."
	esac
done
	
	if [[ ! $instructor ]] || [[ ! -f $studentfile ]] || [[ ! $class ]] || [[ ! $tag ]]; then
		if [ ! $instructor ]; then
			printf "Missing Argument -i <instructor_username>"
		elif [ ! $studentfile ]; then
			printf "Missing Argument -s </path/to/studentfile>\n"

		elif [ ! $class ]; then
			printf "Missing Argument -c <class>\n"

		elif [ ! $tag ]; then
			printf "missing argument -t <searchtag>\n"

		fi
	
		exit 1
fi	

#returnSpot="$sourceRoot/$class/$studentfile/returned"
returnSpot="$sourceRoot/$instructor/$class/submissions"

if [ ! -d $returnSpot ]; then
	printf "%does not exist." "$returnSpot"
	read -p "Would you like to create it? (y/n)" response
	case $response in
		y ) 
			mkdir -p $returnSpot
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


