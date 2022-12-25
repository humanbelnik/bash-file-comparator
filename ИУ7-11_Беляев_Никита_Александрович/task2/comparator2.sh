#!/bin/bash

string="string:"
file_1=$1
file_2=$2
touch /tmp/buffer_1
touch /tmp/buffer_2

if [ -z "$file_1" -o -z "$file2" ]; then
	echo "Некорректная строка запуска (При запуске укажите оба файла)."
else
	flag=false
	while read -r line
	do
		if [ "$flag" == "true" ]; then
			echo "$line" >> /tmp/buffer_1
		else
			for word in $line; do
				if [[ $word =~ $string ]]; then			
				    edited=$(sed 's/SeqStart/NotSeq/; s/string:/SeqStart/' <<< "$line")
					(sed -n -e "s/^.*\(SeqStart.*\)/\1/p" <<< "$edited") > /tmp/buffer_1
					flag=true
					break
				fi
			done
		fi
	done < "$file_1"

	flag=false
	while read -r line
	do
		if [ "$flag" = "true" ]; then
			echo "$line" >> /tmp/buffer_2
		else
			for word in $line; do
				if [[ $word =~ $string ]]; then			
					edited=$(sed 's/SeqStart/NotSeq/; s/string:/SeqStart/' <<< "$line")
					(sed -n -e "s/^.*\(SeqStart.*\)/\1/p" <<< "$edited") > /tmp/buffer_2
					flag=true
					break
				fi
			done
		fi
	done < "$file_2"

if [ -s /tmp/buffer_1 -o -s /tmp/buffer_2 ]; then
	if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
		echo 0
	else
		echo 1
	fi
else
	echo "Ни в одном из файлов нет подстроки 'string:'."
fi

rm /tmp/buffer_1 /tmp/buffer_2