#!/bin/bash

bMain=true

while $bMain;
do

	echo "Необходимо выбрать действие:"
	echo "1 - Средняя оценка студента"
	echo "2 - Занятие с максимальной посещаемостью группы"
	echo "3 - Занятие с минимальной посещаемостью группы"
	echo "0 - Возврат в выбор части задания"

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
			buffer=$(grep -rhi "$name" ./labfiles/Криптозоология/tests)
			if [ -n "$buffer" ]
			then

				name=$( echo "${name^}"  )

				declare -a namesArray
				declare -a namesArrayRaw

				namesArrayRaw+=( $(grep -rh "$name" ./labfiles/Криптозоология/tests | sed "s/.*;\($name..\);.*/\1/") )
				for nameRaw in ${namesArrayRaw[@]}; do

					searchResult=false
					for elem in ${namesArray[@]}; do
						if [ $nameRaw = $elem ]
						then
							searchResult=true
						fi
					done

					if [ "$searchResult" = false ]
					then
						namesArray+=( $nameRaw )
					fi

				done

				declare -a marksArray
				for elem in ${namesArray[@]}; do

					marksArray=()
					summ=0

					marksArray+=( $(grep -rh "$elem" ./labfiles/Криптозоология/tests | grep ';[3-5]$' | sed "s/.*;\([3-5]\)$/\1/") )
					for i in ${marksArray[@]}; do
						summ=$(( $summ + $i ))
					done

					summ=$((100*summ/4))
					echo "Средний балл по Криптозоологии студента $elem: $summ" | sed 's/\(..\)$/\.\1/'

					summ=0
					marksArray=()

					marksArray+=( $(grep -rh "$elem" ./labfiles/Пивоварение/tests | grep ';[3-5]$' | sed "s/.*;\([3-5]\)$/\1/") )
					for i in ${marksArray[@]}; do
						summ=$(( $summ + $i ))
					done

					summ=$((100*summ/4))
					echo "Средний балл по Пивоварению студента $elem: $summ" | sed 's/\(..\)$/\.\1/'
				done

				unset marksArray
				unset namesArray
				unset namesArrayRaw
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
		group=$( echo $group | sed -e 's/а/A/' -e 's/А/A/' -e 's/a/A/' )
		
		case "$group" in
			"0") bTask2=false ;;
			*)

			buffer=$(find ./labfiles/Криптозоология/ -name "$group-attendance")
			if [ -n "$buffer" ]  #если строка не пустая
			then

				declare -a attendanceArray

				for i in {0..17}
				do
					attendanceArray+=( $(find ./labfiles/Криптозоология/ -name "$group-attendance" | xargs grep -c "[0-1]\{$i\}1[0-1]\{$((17-i))\}") )
				done


				maxIndex=1
				maxCount=${attendanceArray[0]}

				for i in {1..17}
				do
					if (($maxCount<${attendanceArray[$i]}))
					then
						maxIndex=($((i+1)))
						maxCount=${attendanceArray[$i]}
					fi
				done

				echo "Занятие с максимальной посещаемостью на Криптозоологии для группы $group: $maxIndex."
				echo "Число студентов, посетивших занятие: $maxCount"

				attendanceArray=()

				for i in {0..17}
				do
					attendanceArray+=( $(find ./labfiles/Пивоварение/ -name "$group-attendance" | xargs grep -c "[0-1]\{$i\}1[0-1]\{$((17-i))\}") )
				done

				maxIndex=1
				maxCount=${attendanceArray[0]}

				for i in {1..17}
				do
					if (($maxCount<${attendanceArray[$i]}))
					then
						maxIndex=($((i+1)))
						maxCount=${attendanceArray[$i]}
					fi
				done

				echo "Занятие с максимальной посещаемостью на Пивоварении для группы $group: $maxIndex."
				echo "Число студентов, посетивших занятие: $maxCount"

				unset $attendanceArray
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

		echo "Введите номер группы [A-XX-XX]:"
		echo "0, чтобы вернуться к выбору действия."

		read group
		group=$( echo $group | sed -e 's/а/A/' -e 's/А/A/' -e 's/a/A/' )

		case "$group" in
			"0") bTask3=false ;;
			*)

			buffer=$(find ./labfiles/Криптозоология/ -name "$group-attendance")
			if [ -n "$buffer" ]  #если строка не пустая
			then

				declare -a attendanceArray

				for i in {0..17}
				do
					attendanceArray+=( $(find ./labfiles/Криптозоология/ -name "$group-attendance" | xargs grep -c "[0-1]\{$i\}1[0-1]\{$((17-i))\}") )
				done


				minIndex=1
				minCount=${attendanceArray[0]}

				for i in {1..17}
				do
					if ((${attendanceArray[$i]}<$minCount))
					then
						minIndex=($((i+1)))
						minCount=${attendanceArray[$i]}
					fi
				done

				echo "Занятие с минимальной посещаемостью на Криптозоологии для группы $group: $minIndex."
				echo "Число студентов, посетивших занятие: $minCount"

				attendanceArray=()

				for i in {0..17}
				do
					attendanceArray+=( $(find ./labfiles/Пивоварение/ -name "$group-attendance" | xargs grep -c "[0-1]\{$i\}1[0-1]\{$((17-i))\}") )
				done

				minIndex=1
				minCount=${attendanceArray[0]}

				for i in {1..17}
				do
					if ((${attendanceArray[$i]}<$minCount))
					then
						minIndex=($((i+1)))
						minCount=${attendanceArray[$i]}
					fi
				done

				echo "Занятие с минимальной посещаемостью на Пивоварении для группы $group: $minIndex."
				echo "Число студентов, посетивших занятие: $minCount"

				unset $attendanceArray
				bTask3=false

			else
				echo "Ошибка: Группа не найдена."
			fi
			;;
		esac
		done
		;;
		"0")
		bMain=false
		;;

		*)
		echo "Ошибка: Нет такой команды. Повторите ввод."
		;;
	esac

done
