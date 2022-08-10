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
  echo $file_name
    case $(file -b $file_name) in

      "ASCII text" | "ASCII text, with CRLF line terminators" | "ASCII text, with no line terminators")
        read cmd < <(echo "${type}_arr2+=($(cat $file_name))")
        eval $cmd
        echo "text"
        ;;

      "directory")
        echo "dir"
        ;;

      *)
        echo "root"
        ;;
    esac
  done
done