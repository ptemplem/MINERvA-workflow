#!/usr/bin/bash

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--outdir)  outdir="$2";    shift  ;;
        *) echo "Unknown parameter passed: $1"
    esac
    shift
done

# First, extract playlist name from each mc file
for file_name in ${mc_arr[@]}; do 
  pl=$(echo $file_name | grep -i _me.._ -o -m 1 | tr -d "_")
  if [ -z "$pl" ]; then
    echo "WARNING: playlist name not found!"
    pl="ALL"
  fi
  mkdir -p ${outdir}/plist/${pl} #Second, move all files to plist folder
  echo $pl > ${outdir}/plist/${pl}/plist.txt
  if [[ $pl == "ALL" ]]; then
    cat ${mc_arr[@]} > ${outdir}/plist/${pl}/mc.txt
    cat $data ${outdir}/plist/${pl}/data.txt
    break
  fi
  cat $file_name >> ${outdir}/plist/${pl}/mc.txt
  cat $(echo $data | tr " " "\n" | grep -i $pl) >> ${outdir}/plist/${pl}/data.txt
done