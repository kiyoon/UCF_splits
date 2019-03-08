#!/bin/bash

# Author: Kiyoon Kim (yoonkr33@gmail.com)
# Description: Split(hard link) UCF101 dataset with provided Three Splits text files.

if [ $# -lt 2 ]
then
	echo "Usage: $0 [Dataset location] [Output directory]"
	echo "Split(hard link) UCF101 dataset with provided Three Splits text files."
	echo "Author: Kiyoon Kim (yoonkr33@gmail.com)"
	exit 0
fi

split_dir="ucfTrainTestlist"
data_dir=$(realpath "$1")

mkdir -p "$2"
out_dir=$(realpath "$2")

classes=$(find "$data_dir" -mindepth 1 -maxdepth 1 -type d)
if [ $(echo "$classes" | wc -l) -ne 101 ]
then
	echo "Error: dataset contains less or more than 101 classes." 1>&2
	exit 1
fi

echo "$classes" | while read line
do
	name=$(basename "$line")
	for i in {1..3}
	do
		for phase in train val
		do
			mkdir -p "$out_dir/$phase$i/$name" 
		done
	done
done

for i in {1..3}
do
	cat "$split_dir/trainlist0$i.txt" | awk '{print $1}' | xargs -i sh -c "cp -al '$data_dir/{}'* '$out_dir/val$i'"
	cat "$split_dir/testlist0$i.txt" | awk '{print $1}' | xargs -i sh -c "cp -al '$data_dir/{}'* '$out_dir/val$i'"
done
