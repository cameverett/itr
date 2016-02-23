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
