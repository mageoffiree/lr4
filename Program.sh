#!/bin/bash

bMain=true

while $bMain;
do
    echo
	echo "Приветвуем вас в лучшей программе для работы с вашими файлами!"
    echo
	echo "1 - Перваая часть;"
    echo "2 - Вторая часть;"
    echo "0 - Выход."
	echo

	read number

	case "$number" in
		"0") 
    		bMain=false
		;;

		"1")
	    	chmod a+x ./Part1.sh
            source ./Part1.sh
		;;

		"2")
			chmod a+x ./Part2.sh
            source ./Part2.sh
		;;

		*)
			echo "Ошибка: Нет такой команды. Повторите ввод."
		;;

	esac
done