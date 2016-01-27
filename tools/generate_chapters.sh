#!/bin/bash

MAX_NUMBER=10


function check_args()
{
	return 0
}


function print_meta_data()
{
	echo "print meta to file: $1"
	cat <<EOF >> $1
---
title: Your title
author:
- Per Persson
reviewer:
- Sebastian
date: 2016-01-26
abstract:
...
EOF
}


function print_chapter_content()
{
	cat <<EOF >> $1

# Chapter $1
Here chapter _${1}_ starts. Just read on.
EOF
}

while getopts ":n:" opt; do
  case $opt in
    n)
      MAX_NUMBER=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


#
#	check the parsed arguments
#
if ! check_args; then
	echo "failed"
	exit 1
fi


#
#	generate the required files in a loop
#
for idx in `seq -w 1 ${MAX_NUMBER}`; do
	file=book_chapter${idx}.md
	touch ${file}
	if [[ $idx == "01" ]] || [[ $idx == "1" ]]; then
		echo "first item"
		print_meta_data ${file}
	fi
	print_chapter_content ${file}
done



exit 0