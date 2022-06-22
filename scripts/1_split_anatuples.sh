# Source: Madminer Workflow
#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
#set -o errexit
#set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -i|--input_dir)  input_dir="$2";    shift  ;;   # Anatuple Directory
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Actions (splits inputs into individual .txt files)
cd ${TOPDIR}/CC-CH-pip-ana
mkdir Data && cd Data/
i=0
split_file () {
    echo $(cat $1 | tr "," " " | tr "\n" " ") > sfile.txt
    IFS=" " read -a sarr <<< $(cat sfile.txt)
    for sname in ${sarr[@]}; do
        i=$((i+1)) &&
        echo ${sname} > $2_run${i}.txt
    done
}

if [ ${input_dir}Data/*.root == "${input_dir}Data/*.root" ]; then
    : ; else
    for file_name in ${input_dir}Data/*.root; do
        i=$((i+1)) && 
        echo ${file_name} > data_run${i}.txt
    done;
fi
if [ ${input_dir}Data/*.txt == "${input_dir}Data/*.txt" ]; then
    : ; else
    for file_name in ${input_dir}Data/*.txt; do
        split_file ${file_name} "data"
    done;
fi
for file_name in ${input_dir}Data/*; do
    if [ "$(file ${file_name})" == "${file_name}: directory" ] ; then
        if [ ${file_name}/*.root == "${file_name}/*.root" ]; then
            : ; else
            for file_name2 in ${file_name}/*.root; do
                i=$((i+1)) &&
                echo ${file_name2} > data_run${i}.txt
            done;
        fi
        if [ ${file_name}/*.txt == "${file_name}/*.txt" ]; then
            : ; else
            for file_name2 in ${file_name}/*.txt; do
                split_file ${file_name2} "data"
            done;
        fi    
    fi
done

# Repeat above for MC files
cd .. && mkdir MC/ && cd MC/
i=0
if [ ${input_dir}MC/*.root == "${input_dir}MC/*.root" ]; then
    : ; else
    for file_name in ${input_dir}MC/*.root; do
        i=$((i+1)) && 
        echo ${file_name} > mc_run${i}.txt
    done;
fi
if [ ${input_dir}MC/*.txt == "${input_dir}MC/*.txt" ]; then
    : ; else
    for file_name in ${input_dir}MC/*.txt; do
        split_file ${file_name} "mc"
    done;
fi
for file_name in ${input_dir}MC/*; do
    if [ "$(file ${file_name})" == "${file_name}: directory" ] ; then
        if [ ${file_name}/*.root == "${file_name}/*.root" ]; then
            : ; else
            for file_name2 in ${file_name}/*.root; do
                i=$((i+1)) &&
                echo ${file_name2} > mc_run${i}.txt
            done;
        fi
        if [ ${file_name}/*.txt == "${file_name}/*.txt" ]; then
            : ; else
            for file_name2 in ${file_name}/*.txt; do
                split_file ${file_name2} "mc"
            done;
        fi    
    fi
done
rm sfile.txt