#!/bin/bash

touch "$HOME/.bash_aliases"
printf "alias classman=\'bash $HOME/itr/classman.sh\'" >> "$HOME/.bash_aliases\n"
printf "alias cls=\'clear && ls\'" >> "$HOME/.bash_aliases\n"

sudo usermod -G instructors $1
