#!/bin/bash

string="string:"
file_1="./tests/file1"
file_2="./tests/file2"
touch /tmp/buffer_1
touch /tmp/buffer_2


echo ">> First file <<"

cat $file_1
echo " "
echo ">> Second file <<"

cat $file_2
echo " "

flag=false
while read -r line
do
	# "Print" debugging 
	echo "Current line:"
	echo "$line"
	echo " "

	if [ "$flag" = "true" ]; then
		echo "$line" >> /tmp/buffer_1
	else
		for word in $line; do
			if [[ $word =~ $string ]]; then

				echo "Got it! First appearence of the substring 'string' in line:"
				echo "$line"

				edited=$(sed 's/SeqStart/NotSeq/; s/string:/SeqStart/' <<< "$line")
				(sed -n -e "s/^.*\(SeqStart.*\)/\1/p" <<< "$edited") > /tmp/buffer_1

				flag=true
				break
			fi
		done
	fi
done < "$file_1"

echo "We have the following sequence in our 1st file:"
cat /tmp/buffer_1
echo " "

flag=false
while read -r line
do
	# "Print" debugging 
	echo "Current line:"
	echo "$line"
	echo " "

	if [ "$flag" = "true" ]; then
		echo "$line" >> /tmp/buffer_2
	else
		for word in $line; do
			if [[ $word =~ $string ]]; then	

				echo "Got it! First appearence of the substring 'string' in line:"
				echo "$line"
				edited=$(sed 's/SeqStart/NotSeq/; s/string:/SeqStart/' <<< "$line")
				(sed -n -e "s/^.*\(SeqStart.*\)/\1/p" <<< "$edited") > /tmp/buffer_2
				flag=true
				break
			fi
		done
	fi
done < "$file_2"

echo "We have the following sequence in our 2nd file:"
cat /tmp/buffer_2
echo " "

echo "Result:"

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

