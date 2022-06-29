# Source: Madminer Workflow
#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
#set -o errexit
#set -o nounset

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--data)  data="$2";    shift  ;;
        -m|--mc)  mc="$2";    shift  ;;
        -h|--histograms)  histograms="$2";    shift  ;;
        -x|--outfile)  outfile="$2";    shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Actions
root -b -q loadLibs.C+ xsec/crossSectionDataFromFile.C+(0,'"'ALL'"','"'${histograms}'"','"'${xsec_inputs}'"','"'${data}'"','"'${mc}'"')