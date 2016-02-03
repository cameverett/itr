#!/bin/bash

sourceRoot="/home/students"
group="instructors"
permissions="770"

# TODO: Parse command line argument passed in classr script --studentfile=<filename>
while [[ ! -f $studentfile ]]; do
	read -p "Student File: " studentfile
done

cat $studentfile | \
while read student; do
	mkdir -p $sourceRoot/$student/{submit,returned,mynotes}
	sudo chown -R "$student:$group" $sourceRoot
	sudo chmod -R $permissions $sourceRoot
done
