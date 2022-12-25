#!/bin/bash

regex="^[-]?[0-9]+[.]?[0-9]+([e][+-]?[0-9]+)?$"
file_1="./tests/file1"
file_2="./tests/file2"
touch /tmp/buffer_1
touch /tmp/buffer_2

	
# "Print-debugging"
echo -e ">> Parsing floating-point numbers from the 1st file.\n\nFirst file:\n" 
cat $file_1


while IFS= read -r line
do
	# Test
	echo " "
	echo ">>Current line:"
	echo $line
	echo "..."

	for word in $line; do
		if [[ $word =~ $regex ]]; then

			# Test
			echo "Caught:"
			echo $word
			echo "..."

			echo $word >> /tmp/buffer_1
		fi
	done
done < "$file_1"

echo "1st floating sequence:"
cat /tmp/buffer_1
echo " "

# "Print-debugging"
echo -e ">> Parsing floating-point numbers from the 2nd file.\n\nSecond file:\n" 
cat $file_2

while IFS= read -r line
do
	echo " "
	echo ">>Current line:"
	echo $line
	echo "..."
	for word in $line; do
		if [[ $word =~ $regex ]]; then

			# Test
			echo "Caught:"
			echo $word
			echo "..."

			echo $word >> /tmp/buffer_2
		fi
	done
done < "$file_2"

echo "2nd floating sequence:"
cat /tmp/buffer_2
echo " "


echo " "
echo "Result (0 - Same floating sequences, 1 - different floating sequences)"
# Comparsion & buffers elimination
if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
	echo 0
else
	echo 1
fi

rm /tmp/buffer_1 /tmp/buffer_2