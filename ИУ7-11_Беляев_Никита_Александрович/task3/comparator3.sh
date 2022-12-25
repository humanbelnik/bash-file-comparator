#!/bin/bash
regex="^[+-]?([0-9]+)(\.([0-9]+))|(e[+-]([0-9]+))?$"
file_1=$1
file_2=$2
touch /tmp/buffer_1
touch /tmp/buffer_2

if [ -z "$file_1" -o -z "$file2" ]; then
	echo "Некорректная строка запуска (При запуске укажите оба файла)."
else
	while IFS= read -r line
	do
		for word in $line; do
			if [[ $word =~ $regex ]]; then
				echo $word >> /tmp/buffer_1
			fi
		done
	done < "$file_1"

	while IFS= read -r line
	do
		for word in $line; do
			if [[ $word =~ $regex ]]; then
				echo $word >> /tmp/buffer_2
			fi
		done
	done < "$file_2"
	
	if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
		echo 0
	else
		echo 1
	fi

	rm /tmp/buffer_1 /tmp/buffer_2
fi