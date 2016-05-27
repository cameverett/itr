#!/bin/bash

touch "$HOME/.bash_aliases"
printf "alias classman='bash $HOME/itr/classman'\n" >> "$HOME/.bash_aliases"

source "$HOME/.bash_aliases"

cat welcome.txt
