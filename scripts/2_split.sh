#!/usr/bin/bash

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--outdir)  outdir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"
    esac
    shift
done

# First, pass all .root file names to data_arr and mc_arr
for type in "data" "mc"; do 
  type_file="${type}_file"
  file_name=${!type_file} #Weird syntax to get dynamic variable to work
  cat $file_name >> ${outdir}/workflow_${type}_list.txt
  (cat ${outdir}/workflow_${type}_list.txt | tr "," " " | tr $'\n' " " | tr $'\r' " ") > ${outdir}/workflow_${type}_file.txt
  IFS=" " read -a ${type}_arr <<< $(cat ${outdir}/workflow_${type}_file.txt) #Split individual .root file names into array
done
# Second, pass array elements to a group of .txt files. Multiple some .txt files have multiple elements from mc_arr to equalize # of mc and data files
n=$((${#mc_arr[@]}<${#data_arr[@]} ? ${#mc_arr[@]}:${#data_arr[@]})) #Min length out of arrays
for type in "data" "mc"; do 
  i=0
  type_arr="${type}_arr[@]"
  for name in ${!type_arr}; do
    mkdir -p ${outdir}/run_$(($i % $n))
    echo ${name} >> ${outdir}/run_$(($i % $n))/${type}_${plist}_run.txt
    i=$((i+1))
  done
done
rm ${outdir}/workflow*.txt