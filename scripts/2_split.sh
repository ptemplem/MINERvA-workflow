#!/usr/bin/bash

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--outdir)  outdir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"
    esac
    shift
done

# First, pass all .root file names to and mc_arr.
(cat $mc_file | tr "," " " | tr $'\n' " " | tr $'\r' " ") > ${outdir}/temp.txt
IFS=" " read -a mc_arr <<< $(cat ${outdir}/temp.txt) #Split individual .root file names into array
rm ${outdir}/temp.txt
# Second, pass array elements to a group of .txt files. Multiple some .txt files have multiple elements from mc_arr to equalize # of mc and data files
n=$size
i=0
for name in ${mc_arr[@]}; do
  mkdir -p ${outdir}/run_$(($i / $n))
  echo ${name} >> ${outdir}/run_$(($i / $n))/${type}_${plist}_run.txt
  i=$((i+1))
done
