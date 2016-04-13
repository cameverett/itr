#!/bin/bash

echo "Removing ITR Package from your account"

echo "Removing classman alias"
touch $HOME/temp
grep -v "alias classman='bash $HOME/itr/classman.sh'" $HOME/.bash_aliases > $HOME/temp
mv $HOME/temp $HOME/.bash_aliases

echo "Removing repo"
rm -rf "$HOME/itr"
