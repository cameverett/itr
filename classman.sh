#!/bin/bash

showUsage() {
	printf "Usage:\n"
	printf "classman assign -a </path/to/assignment> -s </path/to/studentfile>"
	printf "classman collect -i <instructor> -s </path/to/studentfile> -t <tag>"
	printf "classman create -i <instructor> -s </path/to/studentfile>"
	printf "classman return -i <instructor> -s </path/to/studentfile> -p </path/to/assignments> -f <tag>"
	exit 1
}

action=$1

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
	remove)
		bash $HOME/itr/cleanup.sh
		;;
	create)
		sudo bash $HOME/itr/bash/createDirectories.sh -i $Iflag -s $Sflag
		;;
	return)
		sudo bash $HOME/itr/bash/returnHomework.sh -i $Iflag -s $Sflag -p $Pflag -f $Fflag
esac
