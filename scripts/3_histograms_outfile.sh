#!/usr/bin/env sh

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -t) type="$2";      shift   ;;
        -o) outdir="$2";   shift   ;;
        *) echo "Unknown parameter passed: $1";;
    esac
    shift
done

# Format outfile name
export outfile=${outdir}"/"${type}"_histogram.root"
