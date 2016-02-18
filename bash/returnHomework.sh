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
		echo "You Goofed!"
	exit 1
	fi		
	
