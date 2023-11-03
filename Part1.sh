#!/bin/bash

bMain=true

while $bMain;
do

	echo
	echo "Введите номер группы [A-XX-XX]:"
	echo "0, чтобы вернуться к выбору части задания"
	echo

	read group
	group=$( echo $group | sed -e 's/а/A/' -e 's/А/A/' -e 's/a/A/' )

	case "$group" in
		"0") 
			bMain=false
		;;

		*)
		buffer=$(find ./labfiles/Криптозоология/ -name "$group-attendance")
		if [ -n "$buffer" ]
		then
			bTask10=true
			while $bTask10;
			do
				echo
				echo "Необходимо выбрать действие:"
				echo "1 - Студенты, которые не сдали все с первой попытки"
				echo "2 - Упорядоченный список группы"
				echo "0 - Вернуться к введению номера группы"
				echo

				read Option

				case "$Option" in
					"0") 
						bTask10=false
					;;

					"1")
						echo
						echo "Криптозоология:"
						for i in {1..4}
						do
							echo
							echo "Тест $i"
							grep -h "$group;.*;2\$" ./labfiles/Криптозоология/tests/TEST-$i |  sed -e 's/A-..-..;//g' -e 's/;20[1,2][1-9].*$//g' | sort -u
						done
						
						echo
						echo "Пивоварение:"
						for i in {1..4}
						do
							echo
							echo "Тест $i"
							grep -h "$group;.*;2\$" ./labfiles/Пивоварение/tests/TEST-$i |  sed -e 's/A-..-..;//g' -e 's/;20[1,2][1-9].*$//g' | sort -u
						done
						
					;;

					"2")
						echo 
						echo "Криптозоология:"
						
						for i in {1..4}
						do
							echo
							echo "Тест $i:"
							#egrep \(^\($group\).*$\) ./labfiles/Криптозоология/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[1,2][1-9].*$//g' | uniq -c | sort | sed 's/^.*[1-9].//g'
							#Если нужен список вместе с кол-вом попыток
							egrep \(^\($group\).*$\) ./labfiles/Криптозоология/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[1,2][1-9].*$//g' | uniq -c | sort
						done

						echo
						echo "Пивоварение:"
						
						for i in {1..4}
						do
							echo
							echo "Тест $i:"
							#egrep \(^\($group\).*$\) ./labfiles/Пивоварение/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[1,2][1-9].*$//g' | uniq -c | sort | sed 's/^.*[1-9].//g'
							#Если нужен список вместе с кол-вом попыток
							egrep \(^\($group\).*$\) ./labfiles/Пивоварение/tests/TEST-$i | sed -e 's/A-..-...//g' -e 's/.20[1,2][1-9].*$//g' | uniq -c | sort
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
