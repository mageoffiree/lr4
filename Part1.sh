#!/bin/bash

bMain=true
groupEnter=true

while $bMain;
do

	#создаем и заполняем массив предметов
	declare -a subjects
	subjects+=( $(find ./labfiles/ -maxdepth 1 -type d -not -name "labfiles" -not -name "students" | sed 's/\(.*\)$/\1\//') )
	
	#Вводим номер группы
	while $groupEnter;
	do	
		echo "Введите номер группы [A-XX-XX]:"
		echo "0, чтобы выйти к выбору части задания."
		read group
		
		case "$group" in
		"0")
			unset subjects
			exit 1
		;;
		*)
			group=$( echo $group | sed -e 's/а/A/' -e 's/А/A/' -e 's/a/A/' )
			#ищем записи о группе
			buffer=$(find "${subjects[0]}" -name "$group-attendance")
			echo $buffer
			if [ -n "$buffer" ]  #если строка не пустая
			then
				groupEnter=false
			else
				echo "Ошибка: Группа не найдена."
			fi
		;;
		esac
	done
	
	echo "Выберите пункт:"
	echo "1 - Студенты, у которых есть хотя бы один несданный тест"
	echo "2 - Студенты, которые не сдали тесты с первой попытки"
	echo "3 - Упорядоченный список группы по количеству попыток сдачи теста"
	echo "0 - Вернуться к введению номера группы"

	read Option				
				
	case "$Option" in
		"0") 
			groupEnter=true
		;;

		"1")
		#создаем и заполняем массив, содержащий список группы
			declare -a namesArray
			namesArray+=( $( find "${subjects[0]}" -name "$group-attendance" | xargs sed "s/\(.*\) [0-1]*\$/\1/" ) )
			
			#создаем массив студентов, не сдавших хотя бы один тест
			declare -a studentsFailed
			#создаем массив номеров заваленных тестов
			declare -a testFailed
			
			for subj in ${subjects[@]}; do
				
				#получаем количество тестов по предмету
				testsNumber=$( find "$subj"/tests -type f -name "TEST-*" | grep -c "" )
				#получаем название предмета
				className=$( echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/' )
				
				studentsFailed=()
				testFailed=()
				
				for (( i=1; i<=$testsNumber; i++ ))
				do
					
					for student in ${namesArray[@]}; do
					
					#ищем записи об успешных сдачах теста у студента
					foundTest=$( grep "$student;20..;.\{1,2\};[3-5];" "$subj"/tests/TEST-$i )
					#если записи не найдено, добавляем в массив несдавших
					if [ -n foundTest ]
					then
						
						searchResult=false
						for elem in ${namesArray[@]}; do
						if [ $student = $elem ]
						then
							searchResult=true
						fi
						done
						
						#добавляем в массив, только если студента нет в массиве несдавших
						if [ "$searchResult" = false ]
						then
							studentsFailed+=( $student )
							testFailed+=( $i )
						fi
						
					fi
						
					done
					
				done
				
				echo "Студенты, не сдавшие хотя бы один тест по предмету $className:"
				for (( i=0; i<${#studentsFailed[@]}; i++ ))
				do
					echo "${studentsFailed[i]} (${testFailed[i]})"
				done
				echo
				
			done
			
			unset studentsFailed
			unset namesArray
			unset testFailed
		;;

		"2")
			for subj in ${subjects[@]}; do
				
				#получаем количество тестов по предмету
				testsNumber=$( find "$subj"/tests -type f -name "TEST-*" | grep -c "" )
				#получаем название предмета
				className=$( echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/' )
				
				echo "Студенты, не сдавшие тесты с первой попытки по предмету $className:"
				for (( i=1; i<=$testsNumber; i++ ))
				do
					echo "Тест $i:"
					grep -h "$group;.*;2\$" "$subj"/tests/TEST-$i |  sed -e 's/A-..-..;/   /g' -e 's/;20[0-9][0-9].*$//g' | sort -u
				done
				echo
				
			done	
		;;

		"3")
			for subj in ${subjects[@]}; do
				
				#получаем количество тестов по предмету
				testsNumber=$( find "$subj"/tests -type f -name "TEST-*" | grep -c "" )
				#получаем название предмета
				className=$( echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/' )
				
				echo "Список группы по количество попыток сдачи тестов по предмету $className:"
				for (( i=1; i<=$testsNumber; i++ ))
				do
					echo "Тест $i:"
					egrep \(^\($group\).*$\) "$subj"/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[0-9][0-9].*$//g' | uniq -c | sort
				done
				echo
				
			done
		;;

		*)
			echo "Ошибка: Нет такой команды. Повторите ввод."
		;;
	esac	

	unset subjects
	
done