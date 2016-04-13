#!/bin/bash

touch $HOME/temp
grep -v "alias classman='bash $HOME/itr/classman.sh'"
rm -rf "$HOME/itr"
