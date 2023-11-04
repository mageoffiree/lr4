#!/bin/bash

bMain=true

while $bMain;
do

	declare -a subjects
	subjects+=( $(find ./labfiles/ -maxdepth 1 -type d -not -name "labfiles" -not -name "students" | sed 's/\(.*\)$/\1\//') )
	
	echo "Введите номер группы [A-XX-XX]:"
	echo "0, чтобы вернуться к выбору части задания"

	read group
	group=$( echo $group | sed -e 's/а/A/' -e 's/А/A/' -e 's/a/A/' )

	case "$group" in
		"0") 
			bMain=false
		;;

		*)
		buffer=$(find "${subjects[0]}" -name "$group-attendance")
		if [ -n "$buffer" ]  #если строка не пустая
		then
			bTask10=true
			while $bTask10;
			do
				echo "Необходимо выбрать действие:"
				echo "1 - Студенты, у которых есть непересданные тесты"
				echo "2 - Студенты, которые не сдали все с первой попытки"
				echo "3 - Упорядоченный список группы"
				echo "0 - Вернуться к введению номера группы"

				read Option

				case "$Option" in
					"0") 
						bTask10=false
					;;

					"1")
						for subj in ${subjects[@]}; do
							echo
							echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/'
							for i in {1..4}
							do
								echo "Тест $i"
								grep -h -A 1 "$group;.*;2\$" "$subj"/tests/TEST-$i | sed -e 's/A-..-..;/   /g' -e 's/;20[0-9][0-9];.//g' -e '/--/d' | grep "\n.*2" 
							done
						done	
					;;

					"2")
						for subj in ${subjects[@]}; do
							echo
							echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/'
							for i in {1..4}
							do
								echo "Тест $i"
								grep -h "$group;.*;2\$" "$subj"/tests/TEST-$i |  sed -e 's/A-..-..;/   /g' -e 's/;20[0-9][0-9].*$//g' | sort -u
							done
						done	
					;;

					"3")
						for subj in ${subjects[@]}; do
							echo
							echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/'
						
							for i in {1..4}
							do
								echo "Тест $i:"
								egrep \(^\($group\).*$\) "$subj"/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[0-9][0-9].*$//g' | uniq -c | sort
							done
						done
					;;

					*)
						echo "Ошибка: Нет такой команды. Повторите ввод."
					;;
				esac	
			done
		else
			echo "Ошибка: Группа не найдена."
		fi
		;;
	esac
done