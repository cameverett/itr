sourceRoot="/home/"
group="instructors"
permissions="770"

while getopts ":s:c:t:" opt; do
	case $opt in
	s ) studentfile=$OPTARG;;
	c ) class=$OPTARG;;
	t ) tag=$OPTARG;;
	\?) printf "Usage......."
	esac
done
	
	if [[ ! -f $studentfile ]] || [[ ! $class ]] || [[ ! $tag ]]; then
		if [ ! studentfile ]; then
			printf "Missing Argument -s </path/to/studentfile>\n"

		if [ ! $class ]; then
			printf "Missing Argument -c <class>\n"

		if [ ! $tag ]; then
			printf "missing argument -t <searchtag>\n"

		fi
	
		exit 1
fi	

returnSpot="$sourceRoot/$class/$studentfile/returned"

if [ ! -d $destination ]; then
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


