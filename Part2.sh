#!/bin/bash

bMain=true

while $bMain;
do
	
	#создаем и заполняем массив предметов
	declare -a subjects
	subjects+=( $(find ./labfiles/ -maxdepth 1 -type d -not -name "labfiles" -not -name "students" | sed 's/\(.*\)$/\1\//') )
	
	echo "Выберите пункт:"
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
		name=$( echo "${name^}"  )

		case "$name" in
			"0") bTask1=false ;;
			*)
			buffer=$(grep -rhi ";$name" "${subjects[0]}"/tests)
			if [ -n "$buffer" ]
			then
				
				for subj in ${subjects[@]}; do
				
					#получаем количество тестов по предмету
					testsNumber=$( find "$subj"/tests -type f -name "TEST-*" | grep -c "" )
					#получаем название предмета
					className=$( echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/' )
					
					declare -a namesArray
					declare -a namesArrayRaw
				
					namesArrayRaw+=( $(grep -rh ";$name[A-Z]\?[a-z]\?[A-Z]\?[a-z]\?" "$subj"/tests | sed "s/A-..-..;\($name.*\);20..;.\{1,2\};[2-5]/\1/") )
					
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
						
						#получаем массив оценок
						marksArray+=( $(grep -rh "$elem" "$subj"/tests | grep ';[3-5]$' | sed "s/.*;\([3-5]\)$/\1/") )
						for i in ${marksArray[@]}; do
							summ=$(( $summ + $i ))
						done
						
						#получаем среднее
						summ=$((100*summ/testsNumber))
						echo "Средний балл по предмету студента $elem: $summ" | sed 's/\(..\)$/\.\1/'
						
					done
					
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

		"2" | "3")
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

			buffer=$(find "${subjects[0]}" -name "$group-attendance")
			if [ -n "$buffer" ]  #если строка не пустая
			then

				#массив посещаемости занятия
				declare -a attendanceArray
				
				for subj in ${subjects[@]}; do
				
					#считаем первую строку, убираем имя - получаем количество занятий по предмету, получаем длину строки = кол-во занятий
					classCount=$( find "$subj" -name "$group-attendance" | xargs head -n 1 | sed 's/.* \([0-1]*\)/\1/' )
					classCount=$(( ${#classCount}-1 ))
				
					#получаем название предмета
					className=$( echo $subj | sed 's/\.\/labfiles\/\(.*\)\/.*/\1/' )
				
					#получаем массив с количеством посещений каждого занятия
					attendanceArray=()					
					for (( i=0; i<=$classCount; i++ ))
					do
						attendanceArray+=( $(find "$subj" -name "$group-attendance" | xargs grep -c "[0-1]\{$i\}1[0-1]\{$((17-i))\}") )
					done
				
					mIndex=1
					mCount=${attendanceArray[0]}
					
					case "$Option" in
					"2")
					
					for (( i=1; i<=$classCount; i++ ))
					do
						if (($mCount<${attendanceArray[$i]}))
						then
							mIndex=($((i+1)))
							mCount=${attendanceArray[$i]}
						fi
					done
					echo "Занятие с максимальной посещаемостью по предмету $className для группы $group: $mIndex."
					
					;;
					
					"3")
					
					for (( i=1; i<=$classCount; i++ ))
					do
						if ((${attendanceArray[$i]}<$mCount))
						then
							mIndex=($((i+1)))
							mCount=${attendanceArray[$i]}
						fi
					done
					echo "Занятие с минимальной посещаемостью по предмету $className для группы $group: $mIndex."
					
					;;
					esac

					echo "Число студентов, посетивших занятие: $mCount"
				
				done

				unset attendanceArray
				bTask2=false

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

	unset subjects

done
