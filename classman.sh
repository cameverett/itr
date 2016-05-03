#!/bin/bash

showUsage() {
	printf "Usage:\n"
	printf "\tclassman help\n"
	printf "\tclassman help <action>\n"
	printf "\tclassman collect -i <instructor> -s </path/to/studentfile> -t <tag>\n"
	printf "\tclassman create -i <instructor> -s </path/to/studentfile>\n"
	printf "\tclassman publish -a </path/to/assignment> -s </path/to/studentfile>\n"
	printf "\tclassman return -i <instructor> -s </path/to/studentfile> -p </path/to/assignments> -f <tag>\n"
	exit 1
}

getHelpPage() {
	case $1 in
		collect)
			man $HOME/itr/classman_collect.gz
			printf "Getting collect help page\n"
			;;
		create) 
			man $HOME/itr/classman_create.gz
			printf "Getting create help page\n"
			;;
		publish)
			man $HOME/itr/classman_publish.gz
			printf "Getting publish help page\n"
			;;
		return)
			man $HOME/itr/classman_return.gz
			printf "Getting return help page\n"
			;;
		"" | classman)
			man $HOME/itr/classman_help.gz
			printf "Getting classman help page\n"
			;;
		*)
			printf "No man page for that action\n"
			man $HOME/itr/classman_help.gz
			;;
	esac
}

action=$1
helpPage=$2
instructor=$USER

# Need to shift the positional arguments so that getopts can start from $1
shift

while getopts ":t:s:p:f:a:" opt; do
	case $opt in
		a)
			Aflag=$OPTARG
			;;
		f)
			Fflag=$OPTARG
			;;
		p)
			Pflag=$OPTARG
			;;
		s)
			Sflag=$OPTARG
			;;
		t)
			Tflag=$OPTARG
			;;
		*)
			showUsage
	esac
done

case $action in
	collect)
		sudo bash $HOME/itr/bash/collectHomework.sh -i $instructor -s $Sflag -t $Tflag
		;;
	create)
		sudo bash $HOME/itr/bash/createDirectories.sh -i $instructor -s $Sflag
		;;
	help)
		getHelpPage $helpPage
		;;
	publish)
		sudo bash $HOME/itr/bash/publishHomework.sh -a $Aflag -s $Sflag
		;;
	remove)
		bash $HOME/itr/cleanup.sh
		;;
	return)
		sudo bash $HOME/itr/bash/returnHomework.sh -i $instructor -s $Sflag -p $Pflag -f $Fflag
		;;
	* | help)
		showUsage
esac

