#!/bin/bash

###################################################
## Make users and passwords, from an input file
## Input file formatted with tab separation, like this:
##
## user1 passwd1
## user2 passwd2
## ...
##
## Don't forget:  chmod 755 usermake.sh
## Then run with this command:  sudo ./usermake.sh
###################################################


file="input.txt"
while read user passwd
do
  useradd --create-home "$user"
  echo "$user":"$passwd" | chpasswd
done < $file

## to modify new user's directories systematically, use usermod
## For example, mkdir /home/FAST and insert the following into the loop:
## usermod -m -d /home/FAST/"$user" "$user"