#!/usr/bin/bash

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--outdir)  outdir="$2";    shift  ;;
        -p|--playlist) by_playlist="$2";    shift   ;;
        *) echo "Unknown parameter passed: $1"
    esac
    shift
done

# First, pass all .root file names to data_arr2 and mc_arr2
for type in "data" "mc"; do 
  type_arr="${type}_arr[@]"
  for file_name in ${!type_arr}; do
    case $(file -b $file_name) in

      "ASCII text" | "ASCII text, with CRLF line terminators" | "ASCII text, with no line terminators")
        if ${by_playlist}; then
          read cmd < <(echo "${type}_arr2+=($file_name)") #Weird syntax to get dynamic array name to work
          eval $cmd 
        fi
        cat $file_name >> ${outdir}/workflow_${type}_list.txt
        echo "" >> ${outdir}/workflow_${type}_list.txt #Adds newline
        ;;

      "directory")
        if ${by_playlist}; then
          read cmd < <(echo "${type}_arr2+=($file_name/*.txt)")
          eval $cmd
        fi
        cat $file_name/*.txt >> ${outdir}/workflow_${type}_list.txt
        ;;

      *)
        if ${by_playlist}; then
          read cmd < <(echo "${type}_arr2+=($file_name)")
          eval $cmd
        fi
        echo $file_name >> ${outdir}/workflow_${type}_list.txt
        ;;
    esac
  done
  if ! ${by_playlist}; then
    (cat ${outdir}/workflow_${type}_list.txt | tr "," " " | tr $'\n' " " | tr $'\r' " ") > ${outdir}/${type}file.txt
    IFS=" " read -a ${type}_arr2 <<< $(cat ${outdir}/${type}file.txt) #Here string didn't work in the .yml file (that's why this script exists)
  fi
done
# Next, pass array elements to a group of .txt files. Multiple some .txt files have multiple elements from mc_arr to equalize # of mc and data files
n=$((${#mc_arr2[@]}<${#data_arr2[@]} ? ${#mc_arr2[@]}:${#data_arr2[@]})) #Min length out of arrays
for type in "data" "mc"; do 
  i=0
  type_arr="${type}_arr2[@]"
  for name in ${!type_arr}; do
    case $(file -b $name) in

      "ASCII text" | "ASCII text, with CRLF line terminators" | "ASCII text, with no line terminators")
        cat ${name} >> ${outdir}/${type}_runs/${type}_run$(($i % $n)).txt
        echo "" >> ${outdir}/${type}_runs/${type}_run$(($i % $n)).txt
        ;;

      *)
        echo ${name} >> ${outdir}/${type}_runs/${type}_run$(($i % $n)).txt
        ;;
    esac
    i=$((i+1))
  done
done
# Finally, create index files for the multistep scheduler
i=0
while ((i<n)); do
  echo $i > ${outdir}/index/idx${i}.txt
  i=$((i+1))
done