#!/bin/bash
trap "tput cnorm && kill 0" EXIT
declare -A matrix
num_lines_temp=$(tput lines)
num_cols_temp=$(tput cols)
num_cols=$(($num_cols_temp / 2))
num_lines=$(($num_lines_temp - 6))

if [[ $1 = *.txt ]]; then
  file=$1
  declare -A matrix           # declare associative array arr
  declare -A loaded           # declare associative array arr



  row=0
  while read -r -a line; do


    for ((col=0; col<${#line[@]}; col++)); do
      if [[ ${line[$col]} -eq 0 ]]; then
        loaded[$col,$row]="\e[8m██\e[0m"
      elif [[ ${line[$col]} -eq 1 ]]; then
        loaded[$col,$row]="\e[0;31m██\e[0m"
      fi
      # echo matrix[$row,$col]="${line[$col]}"
    done
    ((row++))
  done < "$file"

  for ((i=0;i<num_cols;i++)) do
    for ((j=0;j<num_lines;j++)) do
      matrix[$i,$j]=${loaded[$i,$j]}
    done
  done
else
  for ((i=0;i<num_cols;i++)) do
    for ((j=0;j<num_lines;j++)) do
      matrix[$i,$j]="\e[8m██\e[0m"
    done
  done
fi


function chose_pattern {
  start=0

  gen=1
  max=0
  born=0
  death=0

  rand_color=0
  progressive=0

  tput civis

  x_cursor=$(($num_cols / 2))
  y_cursor=$(($num_lines / 2))
  matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"

clear
echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
for (( i = 0; i < num_cols_temp; i++ )); do
  printf "_"
done
echo
echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
echo -e "\e[1;35malive at start :\t${start}\e[0m"
for ((j=0;j<num_lines;j++)) do
    for ((i=0;i<num_cols;i++)) do
        printf ${matrix[$i,$j]}
    done
    echo
done

ready_to_evolve=0


  while [[ ready_to_evolve -eq 0 ]]; do
  escape_char=$(printf "\u1b")
  read -rsn1 input # get 1 character
  if [[ $input == $escape_char ]]; then
      read -rsn2 input # read 2 more chars
  fi
  case $input in
    '[A' | 'k')
			clear
			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;30m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi

			if [[ $((y_cursor-1)) -lt 0 ]]; then
				y_cursor=$((num_lines-1))
			else
				y_cursor=$(((y_cursor-1)%num_lines))
			fi

			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[8m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[0;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;31m██\e[0m"
			fi
      echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
      for (( i = 0; i < num_cols_temp; i++ )); do
        printf "_"
      done
      echo
      echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
      echo -e "\e[1;35malive at start :\t${start}\e[0m"

			for ((j=0;j<num_lines;j++)) do
			    for ((i=0;i<num_cols;i++)) do
			        printf ${matrix[$i,$j]}
			    done
			    echo
			done
    ;;
    '[B' | 'j')
			clear
			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;30m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi

			y_cursor=$(((y_cursor+1)%num_lines))

			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[8m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[0;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;31m██\e[0m"
			fi
      echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
      for (( i = 0; i < num_cols_temp; i++ )); do
        printf "_"
      done
      echo
      echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
      echo -e "\e[1;35malive at start :\t${start}\e[0m"

			for ((j=0;j<num_lines;j++)) do
					for ((i=0;i<num_cols;i++)) do
							printf ${matrix[$i,$j]}
					done
					echo
			done
    ;;
    '[D' | 'h')
			clear
			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;30m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi

			if [[ $((x_cursor-1)) -lt 0 ]]; then
				x_cursor=$((num_cols-1))
			else
				x_cursor=$(((x_cursor-1)%num_cols))
			fi

			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[8m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[0;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;31m██\e[0m"
			fi
      echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
      for (( i = 0; i < num_cols_temp; i++ )); do
        printf "_"
      done
      echo
      echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
      echo -e "\e[1;35malive at start :\t${start}\e[0m"
			for ((j=0;j<num_lines;j++)) do
					for ((i=0;i<num_cols;i++)) do
							printf ${matrix[$i,$j]}
					done
					echo
			done
    ;;
    '[C' | 'l')
			clear
			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;30m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi

			x_cursor=$(((x_cursor+1)%num_cols))

			if [[ ${matrix[$x_cursor,$y_cursor]} == "\e[8m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"
			elif [[ ${matrix[$x_cursor,$y_cursor]} == "\e[0;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[1;31m██\e[0m"
			fi
      echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
      for (( i = 0; i < num_cols_temp; i++ )); do
        printf "_"
      done
      echo
      echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
      echo -e "\e[1;35malive at start :\t${start}\e[0m"
			for ((j=0;j<num_lines;j++)) do
					for ((i=0;i<num_cols;i++)) do
							printf ${matrix[$i,$j]}
					done
					echo
			done
    ;;
    's' )
			if [[ ${matrix[$x_cursor,$y_cursor]} != "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			else
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi
      ready_to_evolve=1
      return
    ;;
		'r' )
			if [[ ${matrix[$x_cursor,$y_cursor]} != "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			else
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi
			rand_color=1
      ready_to_evolve=1
      return
    ;;
		'p' )
			if [[ ${matrix[$x_cursor,$y_cursor]} != "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			else
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi
			progressive=1
      ready_to_evolve=1
      return
    ;;
		'b' )
			if [[ ${matrix[$x_cursor,$y_cursor]} != "\e[1;31m██\e[0m" ]]; then
				matrix[$x_cursor,$y_cursor]="\e[8m██\e[0m"
			else
				matrix[$x_cursor,$y_cursor]="\e[0;31m██\e[0m"
			fi
			progressive=1
			rand_color=1
			ready_to_evolve=1
      return
		;;
		'' )
			clear
			if [[ ${matrix[$x_cursor,$y_cursor]} != "\e[1;30m██\e[0m" ]]; then
				start=$((start-1))
				matrix[$x_cursor,$y_cursor]="\e[1;30m██\e[0m"
			else
				start=$((start+1))
				matrix[$x_cursor,$y_cursor]="\e[1;31m██\e[0m"
			fi

      echo -e "\t\e[37mmove cursor : arrow keys/hjkl\t\e[0;37m|\tchange cell : space/enter\t\e[0;37m|\t\e[1;32m start : s \t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive : \e[1;31mp \t\e[0;37m|\t\e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: r\t\e[0;37m|\t\e[1;31mprogre\e[0;31mssive \e[0;37mand \e[1;36mr\e[1;31ma\e[1;32mn\e[1;33md\e[1;34mo\e[1;35mm \e[1;37m: b"
      for (( i = 0; i < num_cols_temp; i++ )); do
        printf "_"
      done
      echo
      echo -e "\e[1;34mgeneration : \t\t${gen}\e[0m"
      echo -e "\e[1;35malive at start :\t${start}\e[0m"
			for ((j=0;j<num_lines;j++)) do
					for ((i=0;i<num_cols;i++)) do
							printf ${matrix[$i,$j]}
					done
					echo
			done
    ;;
  esac
done
}

chose_pattern

function evolve {
	#statements
stopped=0
while [[ stopped -eq 0 ]]; do
    gen=$((gen+1))
    last=0
    alive=0
    declare -A matrix_temp
    for ((j=0;j<num_lines;j++)) do
        for ((i=0;i<num_cols;i++)) do
            if [[ ${matrix[$i,$j]} = "\e[8m██\e[0m" ]]
            then
                count=0
                if [[ $((j-1)) -ge 0 ]] && [[ $((i-1)) -ge 0 ]]; then
                  if [[ $((j+1)) -lt $num_lines ]] && [[ $((i+1)) -lt $num_cols ]]; then
                    if [[ ${matrix[$((i-1)),$((j-1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$((i-1)),$j]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$((i-1)),$((j+1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$i,$((j-1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$i,$((j+1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$((i+1)),$((j-1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$((i+1)),$j]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                    if [[ ${matrix[$((i+1)),$((j+1))]} != "\e[8m██\e[0m" ]]; then
                      count=$((count + 1))
                    fi
                  fi
                fi

                if [[ $count = 3 ]]
                then
                    born=$((born+1))
                    alive=$((alive+1))
                    if [[ $rand_color = 1 ]]; then
                      if [[ $progressive = 1 ]]; then
                        matrix_temp[$i,$j]="\e[1;3$(( ( RANDOM % 7 )  + 1 ))m██\e[0m"
                      else
                        matrix_temp[$i,$j]="\e[0;3$(( ( RANDOM % 7 )  + 1 ))m██\e[0m"
                      fi
                    else
                      if [[ $progressive = 1 ]]; then
                        matrix_temp[$i,$j]="\e[1;31m██\e[0m"
                      else
                        matrix_temp[$i,$j]="\e[0;31m██\e[0m"
                      fi
                    fi
                else
                    matrix_temp[$i,$j]="\e[8m██\e[0m"
                fi
              else
                  last=$((last+1))
                  count=0
                  if [[ $((j-1)) -ge 0 ]] && [[ $((i-1)) -ge 0 ]]; then
                    if [[ $((j+1)) -lt $num_lines ]] && [[ $((i+1)) -lt $num_cols ]]; then
                      if [[ ${matrix[$((i-1)),$((j-1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$((i-1)),$j]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$((i-1)),$((j+1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$i,$((j-1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$i,$((j+1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$((i+1)),$((j-1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$((i+1)),$j]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                      if [[ ${matrix[$((i+1)),$((j+1))]} != "\e[8m██\e[0m" ]]; then
                        count=$((count + 1))
                      fi
                    fi
                  fi

                  if [[ $count = 2 ]] || [[ $count = 3 ]]
                  then
                      alive=$((alive+1))
                      if [[ $rand_color = 1 ]]; then
                        matrix_temp[$i,$j]="\e[0;3$(( ( RANDOM % 7 )  + 1 ))m██\e[0m"
                      else
                        matrix_temp[$i,$j]="\e[0;31m██\e[0m"
                      fi
                  else
                      death=$((death+1))
                      matrix_temp[$i,$j]="\e[8m██\e[0m"
                  fi
            fi
        done
    done
    clear
    if [[ $alive -gt $max ]]; then
      max=$alive
    fi
    if [[ $gen -eq 2 ]]; then
      start=$last
    fi
    echo -e "\t\e[37mstart / pause : space/enter/hjkl\t\e[0;37m|\tsave starting pattern : s\t\e[0;37m|\update starting pattern : u\t\e[0;37m|\tquit : q\e[1;37m"
    for (( i = 0; i < num_cols_temp; i++ )); do
      printf "_"
    done

    echo -e "\e[1;34mgeneration :\t\t${gen}\t\e[1;32malive :\t\t\t${alive}\t\e[1;37mborn :\t${born}\t\e[1;36mmaximum alive : ${max}\e[0m"
    echo -e "\e[1;35malive at start :\t${start}\t\e[1;33malive last generation :\t${last}\t\e[1;31mdeath :\t${death}\e[0m"
    for ((j=0;j<num_lines;j++)) do
        for ((i=0;i<num_cols;i++)) do
            matrix[$i,$j]=${matrix_temp[$i,$j]}
            printf ${matrix[$i,$j]}
        done
        echo
    done
done
}

set -m
evolve &
set +m
pid=$!

function controls {

closed=0
paused=0
datefile=$(date -d 'now' +%F_%X)
filename="pattern-$datefile.txt"
while [[ closed -eq 0 ]]; do
  read -rsn1 input_bis # get 1 character
  case $input_bis in
    '')
        if [[ paused -eq 0 ]]; then
				paused=1

				kill -TSTP $pid
        echo "paused"
        else
          paused=0
          kill -CONT $pid
        fi
		;;
    's')
        paused=1
        echo -n > "$filename"
        for ((j=0;j<num_lines;j++)) do
          for ((i=0;i<num_cols;i++)) do
            if [[ ${matrix[$i,$j]} != "\e[8m██\e[0m" ]]; then
              #statements
              printf "1 " >> "$filename"
            else
              printf "0 " >> "$filename"
            fi
          done
          echo  >> "$filename"
        done
        kill -TSTP $pid
        echo "saved"
    ;;
    'u')
        if [[ $1 = *.txt ]]; then
          paused=1
          echo -n > "$file"
          for ((j=0;j<num_lines;j++)) do
            for ((i=0;i<num_cols;i++)) do
              if [[ ${matrix[$i,$j]} != "\e[8m██\e[0m" ]]; then
                #statements
                printf "1 " >> "$file"
              else
                printf "0 " >> "$file"
              fi
            done
            echo  >> "$file"
          done
          echo "updated"
        else
          echo "error : launched without pattern file"
        fi

    ;;
    'r')
      paused=1
      closed=1
      kill -INT $pid
      chose_pattern
      set -m
      evolve &
      set +m
      pid=$!
      controls
    ;;
    'q')
      tput cnorm
      kill -INT $pid
      echo "exiting"
      kill 0
      exit
    ;;
	esac
done
}
controls

wait
