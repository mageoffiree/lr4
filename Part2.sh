#!/bin/bash

bMain=true

while $bMain;
do

	echo "Необходимо выбрать действие:"
	echo "1 - Средняя оценка студента"
	echo "2 - Занятие с максимальной посещаемостью группы"
	echo "3 - Занятие с минимальной посещаемостью группы"
	echo "4 - Возврат в выбор части задания"

	read Option

	case "$Option" in
		"1")
		
		bTask1=true
		
		while $bTask1;
		do
		
		echo "Введите фамилию студента:"
		echo "0, чтобы вернуться к выбору действия."
		
		read name
		
		case "$name" in
			"0") bTask1=false ;;
			*)
			buffer=$(grep -rh "$name" ./labfiles/Криптозоология/tests)
			if [ -n "$buffer" ]
			then
			
				declare -a namesArray
				grep -rh "$name" ./labfiles/Криптозоология/tests | sed 's/.*;\($name..\);*./\1/' | xargs -f addLineInArray
			
				for elem in ${namesArray[@]}; do
					summ=0
					grep -rh "$elem" ./labfiles/Криптозоология/tests | grep ';[3-5]$' | awk -F";" '{summ += $NF}'
					summ=$((100*summ/4))
					echo "Средний балл по Криптозоологии студента $name: $summ" | sed 's/..$/.&/;t' -e 's/.$/.0&/'
					summ=0
					grep -rh "$elem" ./labfiles/Пивоварение/tests | grep ';[3-5]$' | awk -F";" '{summ += $NF}'
					summ=$((100*summ/4))
					echo "Средний балл по Пивоварению студента $name: $summ" | sed 's/..$/.&/;t' -e 's/.$/.0&/'
				done
				
				unset namesArray
				bTask1=false
				
			else
				echo "Ошибка: Студент не найден."
			fi
			;;
		esac
		done
		;;
		
		"2")
		bTask2=true
		
		while $bTask2;
		do
		
		echo "Введите номер группы [A-XX-XX]:"
		echo "0, чтобы вернуться к выбору действия."
		
		read group
		
		case "$group" in
			"0") bTask2=false ;;
			*)
		
			buffer=$(grep -rh "$group" ./labfiles/Криптозоология/tests)
			if [ -n "$buffer" ]
			then
				
				declare -a attandanceArray
				
				for i in {0..18}
				do
					grep -rh "$group" ./labfiles/Криптозоология/tests | grep -c ' .{$((i-1))}.*\$' | awk '$attandanceArray[$i]=$1'
				done
				
				index=0
				maxCount=${attandanceArray[0]}
				
				for i in {1..18}
				do
					if (( ${attandanceArray[${i}]} -gt $maxCount ))
					then
						maxCount=${attandanceArray[${i}]}
						index=($i)
					fi
				done
				
				echo "Занятие с максимальной посещаемостью на Криптозоологии для группы $group: $((index+1))"
				
				for i in {1..18}
				do
					grep -rh "$group" ./labfiles/Пивоварение/tests | grep -c ' .{\$((i-1))}.*$' | awk '$attandanceArray[$i]=$1'
				done
				
				index=0
				maxCount=${attandanceArray[0]}
				
				for i in {1..18}
				do
					if (( ${attandanceArray[${i}]} -gt $maxCount ))
					then
						maxCount=${attandanceArray[${i}]}
						index=($i)
					fi
				done
				
				echo "Занятие с максимальной посещаемостью на Пивоварении для группы $group: $((index+1))"
				
				unset $attandanceArray
				bTask2=false
				
			else
				echo "Ошибка: Группа не найдена."
			fi
			;;
		esac
		done
		;;
		"3")
		
		bTask3=true
		
		while $bTask3;
		do
		
		echo "Введите номер группы \[A-XX-XX\]:"
		echo "0, чтобы вернуться к выбору действия."
		
		read group

		case "$group" in
			"0") bTask3=false ;;
			*)
		
			buffer=$(grep -rh "$group" ./labfiles/Криптозоология/tests)
			if [ -n "$buffer" ]
			then
				
				declare -a attandanceArray
				
				for i in {0..18}
				do
					grep -rh "$group" ./labfiles/Криптозоология/tests | grep -c ' .{\$((i-1))}.*$' | awk '$attandanceArray[$i]=$1'
				done
				
				index=0
				minCount=${attandanceArray[0]}
				
				for i in {1..18}
				do
					if [${attandanceArray[$i]} -lt $minCount]
					then
						minCount=${attandanceArray[$i]}
						index=$i
					fi
				done
				
				echo "Занятие с максимальной посещаемостью на Криптозоологии для группы $group: $index"
				
				for i in {0..18}
				do
					grep -rh "$group" ./labfiles/Пивоварение/tests | grep -c ' .{\$((i-1))}.*$' | awk '$attandanceArray[$i]=$1'
				done
				
				index=0
				minCount=${attandanceArray[0]}
				
				for i in {1..18}
				do
					if [${attandanceArray[$i]} -lt $minCount]
					then
						minCount=${attandanceArray[i]}
						index=$i
					fi
				done
				
				echo "Занятие с максимальной посещаемостью на Пивоварении для группы $group: $index"
				
				unset $attandanceArray
				bTask3=false
				
			else
				echo "Ошибка: Группа не найдена."
			fi
			;;
		esac
		done
		;;
		"4")
		bMain=false
		;;
		
		*)
		echo "Ошибка: Нет такой команды. Повторите ввод."
		;;
	esac
	
done


function isElementInArray {
	local searchResult=false
	for elem in ${namesArray[@]}; do
		if [elem -eq $1]
		then
			searchResult=true
		fi
	return searchResult
	done
}

function addLineInArray {
	local flag=$(isElementInArray $1)
	if [flag -eq false]
	then
		namesArray+=( $1 )
	fi
}