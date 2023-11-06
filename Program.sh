#!/bin/bash

bM=true

while $bM;
do
    echo
	echo "Приветвуем вас в лучшей программе для работы с вашими файлами!"
    echo
	echo "1 - Первая задача"
    echo "2 - Вторая задача"
    echo "0 - Выход."
	echo

	read number

	case "$number" in
		"0") 
    		bM=false
		;;

		"1")
            ./Part1.sh

		;;

		"2")
            ./Part2.sh
		;;

		*)
			echo "Ошибка: Нет такой команды. Повторите ввод."
		;;

	esac
done