#! /bin/bash
# filename: calc.sh
ANS=$(cat ANS.txt)
# Calculate number of lines in HIST.txt
num_lines=$(wc -l <HIST.txt)
read -r -p ">> " num1 op num2
# EXIT to exit the program
if [ "$num1" = "EXIT" ]; then
	exit 0
# HIST to echo 5 lastest successful calculations
elif [ "$num1" = "HIST" ]; then
	cat HIST.txt
	exit 0
# RESET to reset the ANS.txt
elif [ "$num1" = "RESET" ]; then
	# reset ANS.txt
	echo "0" >ANS.txt
	# empty HIST.txt
	echo -n >HIST.txt
	exit 0
elif [ "$num1" = "ANS" ]; then
	num1="$ANS"
fi
if [ "$num2" = "ANS" ]; then
	num2="$ANS"
fi

case $op in
"+")
	res=$(awk -v num1="$num1" -v num2="$num2" 'BEGIN {printf "%.2f", num1+num2}')
	if [[ "$res" == *".00" ]]; then
		res=${res%.*}
	fi
	;;
"-")
	res=$(awk -v num1="$num1" -v num2="$num2" 'BEGIN {printf "%.2f", num1-num2}')
	if [[ "$res" == *".00" ]]; then
		res=${res%.*}
	fi
	;;
"*")
	res=$(awk -v num1="$num1" -v num2="$num2" 'BEGIN {printf "%.2f", num1*num2}')
	if [[ "$res" == *".00" ]]; then
		res=${res%.*}
	fi
	;;
"/")
	if [ "$num2" -eq 0 ]; then
		echo "MATH ERROR"
		exit 1
	fi
	res=$(awk -v num1="$num1" -v num2="$num2" 'BEGIN {printf "%.2f", num1/num2}')
	if [[ "$res" == *".00" ]]; then
		res=${res%.*}
	fi
	;;
"%")
	if [ "$num2" -eq 0 ]; then
		echo "MATH ERROR"
		exit 1
	fi
	if [[ $num1 == *"."* || $num2 == *"."* ]]; then
		echo "SYNTAX ERROR"
		exit 1
	fi
	res="$((num1 % num2))"
	;;
*)
	echo "SYNTAX ERROR"
	exit 1
	;;
esac
# write the result to ANS.txt
echo "$res" >ANS.txt
# if HIST.txt has less than 5 lines, append the result to the end of the file
if [ "$num_lines" -lt 5 ]; then
	if [ "$num_lines" -eq 0 ]; then
		# if HIST.txt is empty, write the result to the first line
		echo "$num1 $op $num2 = $res" >HIST.txt
	else
		echo "$num1 $op $num2 = $res" >>HIST.txt
	fi
else
	sed -i '1d' HIST.txt
	echo "$num1 $op $num2 = $res" >>HIST.txt
fi
# echo the result
echo "$res"
