#!/bin/bash

bMain=true

while $bMain;
do

	echo
	echo "Введите номер группы [A-XX-XX]:"
	echo "0, чтобы вернуться к выбору части задания"
	echo

	read group

	case "$group" in
		"0") bMain=false ;;
		*)

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
			"0") bTask10=false;;

			"1")
			echo
			echo "Криптозоология:"
			egrep \(^\($group\).*2$\) ./labfiles/Криптозоология/tests/TEST-* |  sed -e 's/^.*\/T/T/g' -e 's/.A-..-.../ /g' -e 's/..20[1,2][1-9].*$//g' | sort -u
			echo
			echo "Пивоварение:"
			egrep \(^\($group\).*2$\) ./labfiles/Пивоварение/tests/TEST-* |  sed -e 's/^.*\/T/T/g' -e 's/.A-..-.../ /g' -e 's/..20[1,2][1-9].*$//g' | sort -u
			
			esac
			done
			;;
			"2")

			esac
			done
			;;
			*)
			echo "Ошибка: Нет такой команды. Повторите ввод."
			;;

		else
			echo "Ошибка: Группа не найдена."
		fi
		;;
	esac

done
