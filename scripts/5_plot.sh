#!/usr/bin/env sh

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -o|--outdir)  outdir="$2";    shift  ;;   # Input
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Move Truth Plots (Also won't work in .yml file)
shopt -s extglob
mv !(Eff*|*Genie_Int*|*Target*|*Detector*|*LEGENDONLY*).png ${outdir}
# Note the Genie, Target, and Detector plots are empty, so they won't be published unless this can be fixed
