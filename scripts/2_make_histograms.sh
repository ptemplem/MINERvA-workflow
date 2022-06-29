# Source: Madminer Workflow
#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
#set -o errexit
#set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -i|--mc_run)  mc_run="$2";    shift  ;;   # Input
        -o|--outfile)  outfile="$2";    shift  ;;   # Outfile Name
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Extract Run id
IFS="/" read -a mc_arr <<< "${mc_run}"
id=${mc_arr[$((${#mc_arr[@]}-1))]}
id=$(echo ${id} | tr -d "_.a-z")
# Analysis Specific Code
cd ${TOPDIR}/CC-CH-pip-ana
source ../opt/bin/setup.sh
./clean
root -b -l loadLibs.C++ xsec/makeCrossSectionMCInputs.C+(0,'"'ME1A'"',false,false,false,'"'$(cat ${mc_run})'"',0,'"'${id}'"','"'${outfile}'"')
# makeCrossSectionMCInputs(int signal_definition_int = 0,
#                            bool do_truth = false, bool is_grid = false,
#                              std::string input_file = "", int run = 0, std::string input_id = "")