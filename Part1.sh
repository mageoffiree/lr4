#!/bin/bash

bMain=true

while $bMain;
do

	echo "Введите номер группы [A-XX-XX]:"
	echo "0, чтобы вернуться к выбору части задания"

	read group

	case "$group" in
		"0") bMain=false ;;
		*)

		bTask10=true
		while $bTask10;
		do
			echo "Необходимо выбрать действие:"
			echo "1 - Студенты, которые не сдали все с первой попытки"
			echo "2 - Упорядоченный список группы"
			echo "0 - Вернуться к введению номера группы"

			read Option

			case "$Option" in
			"0") bTask10=false;;

			"1")
			grep -r (;2$) ./labfiles/*/tests/TEST-*)

			"2")

			*)
			echo "Ошибка: Нет такой команды. Повторите ввод."
			;;

		else
			echo "Ошибка: Группа не найдена."
		fi
		;;
	esac

done






