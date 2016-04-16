#!/bin/bash

showUsage() {
	printf "Usage:\n"
	printf "\tclassman assign -a </path/to/assignment> -s </path/to/studentfile>\n"
	printf "\tclassman collect -i <instructor> -s </path/to/studentfile> -t <tag>\n"
	printf "\tclassman create -i <instructor> -s </path/to/studentfile>\n"
	printf "\tclassman return -i <instructor> -s </path/to/studentfile> -p </path/to/assignments> -f <tag>\n"
	printf "\tclassman help <action>\n"
	exit 1
}

getHelpPage() {
	case $1 in
		assign)
			man ./classman_assign
			printf "Getting assign help page\n"
			;;
		collect)
			man ./classman_collect
			printf "Getting collect help page\n"
			;;
		create) 
			man ./classman_create
			printf "Getting create help page\n"
			;;
		return)
			man ./classman_return
			printf "Getting return help page\n"
			;;
		"" | classman)
			man ./classman_help
			printf "Getting classman help page\n"
			;;
		*)
			printf "No man page for that action\n"
			;;
	esac
}

action=$1
helpPage=$2

# Need to shift the positional arguments so that getopts can start from $1
shift

while getopts ":i:t:s:p:f:a:" opt; do
	case $opt in
		i)
			Iflag=$OPTARG
			;;
		t)
			Tflag=$OPTARG
			;;
		s)
			Sflag=$OPTARG
			;;
		p)
			Pflag=$OPTARG
			;;
		f)
			Fflag=$OPTARG
			;;
		a)
			Aflag=$OPTARG
			;;
		*)
			showUsage
	esac
done

case $action in
	assign)
		sudo bash $HOME/itr/bash/assignHomework.sh -a $Aflag -s $Sflag
		;;
	collect)
		sudo bash $HOME/itr/bash/collectHomework.sh -i $Iflag -s $Sflag -t $Tflag
		;;
	help)
		getHelpPage $helpPage
		;;
	remove)
		bash $HOME/itr/cleanup.sh
		;;
	create)
		sudo bash $HOME/itr/bash/createDirectories.sh -i $Iflag -s $Sflag
		;;
	return)
		sudo bash $HOME/itr/bash/returnHomework.sh -i $Iflag -s $Sflag -p $Pflag -f $Fflag
		;;
	* | help)
		showUsage
esac

