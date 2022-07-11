#!/usr/bin/env sh

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -i|--mc_run)  mc_run="$2";    shift  ;;   # Input
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Extract Run id
IFS="/" read -a mc_arr <<< "${mc_run}"
id=${mc_arr[$((${#mc_arr[@]}-1))]}
export id=$(echo ${id} | tr -d "_.a-z")

# makeCrossSectionMCInputs(int signal_definition_int = 0,
#                            bool do_truth = false, bool is_grid = false,
#                              std::string input_file = "", int run = 0, std::string input_id = "")