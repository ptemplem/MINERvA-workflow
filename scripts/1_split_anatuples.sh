#!/usr/bin/env sh

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--outdir)  outdir="$2";    shift  ;;
#        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Actions (splits mc inputs into individual mc_run.txt files)

mkdir ${outdir}/mc_runs
(cat ${outdir}/workflow_mc_list.txt | tr "," " " | tr $'\n' " " | tr $'\r' " ") > ${outdir}/sfile.txt
IFS=" " read -a sarr <<< $(cat ${outdir}/sfile.txt) #Here string didn't work in the .yml file (that's why this script exists)
i=0
for sname in ${sarr[@]}; do
  i=$((i+1))
  echo -n ${sname} > ${outdir}/mc_runs/mc_run${i}.txt
done;