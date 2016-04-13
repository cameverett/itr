#!/bin/bash

touch "$HOME/.bash_aliases"
printf "alias classman='bash $HOME/itr/classman.sh'" >> "$HOME/.bash_aliases"
printf "alias cls='clear && ls'" >> "$HOME/.bash_aliases"

sudo usermod -G instructors $1
