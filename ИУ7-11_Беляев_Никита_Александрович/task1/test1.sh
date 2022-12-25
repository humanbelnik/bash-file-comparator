#!/bin/bash

regex="^-?[0-9]+$"
file_1="./tests/file1"
file_2="./tests/file2"
touch /tmp/buffer_1
touch /tmp/buffer_2

# "Print-debugging"
echo -e ">> Parsing integers from the 1st file.\n\nFirst file:" 
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


# Same parse with the 2nd file and buffer_2. 

# "Print-debugging"
echo -e ">> Parsing integers from the 2nd file.\n\nSecond file:" 
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


echo " "
echo "Result (0 - Same integer sequences, 1 - different integer sequences)"
# Comparsion & buffers elimination
if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
	echo 0
else
	echo 1
fi

rm /tmp/buffer_1 /tmp/buffer_2
