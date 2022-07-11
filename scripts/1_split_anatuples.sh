#!/usr/bin/env sh

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -m|--mc)  mc="$2";    shift  ;;
        -d|--dir)  dir="$2";    shift  ;;
#        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Actions (splits mc inputs into individual mc_run.txt files)

mkdir ${dir}/mc_runs
i=0
(cat ${mc} | tr "," " " | tr $'\n' " " | tr $'\r' " ") > sfile.txt
IFS=" " read -a sarr <<< $(cat sfile.txt) #Here string didn't work in the .yml file (that's why this script exists)
for sname in ${sarr[@]}; do
  i=$((i+1))
  echo -n ${sname} > ${dir}/mc_runs/mc_run${i}.txt
done;