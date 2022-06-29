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

split_file () {
    (cat $1 | tr "," " " | tr $'\n' " " | tr $'\r' " ") > sfile.txt
    IFS=" " read -a sarr <<< $(cat sfile.txt)
    for sname in ${sarr[@]}; do
        if [ $2 == "mc" ]; then
            i=$((i+1)) &&
            echo -n ${sname} > mc_runs/mc_run${i}.txt;
        fi
        echo ${sname} >> $2_list.txt
    done
}

touch data_list.txt
if [ ${input_dir}/Data/*.root == "${input_dir}/Data/*.root" ]; then  # (If .root files don't exist)
    : ; else
    for file_name in ${input_dir}Data/*.root; do
        echo ${file_name} >> data_list.txt
    done;
fi
if [ ${input_dir}/Data/*.txt == "${input_dir}/Data/*.txt" ]; then
    : ; else
    for file_name in ${input_dir}/Data/*.txt; do
        split_file ${file_name} "data"
    done;
fi
for file_name in ${input_dir}/Data/*; do
    if [ "$(file ${file_name})" == "${file_name}: directory" ] ; then
        if [ ${file_name}/*.root == "${file_name}/*.root" ]; then
            : ; else
            for file_name2 in ${file_name}/*.root; do
                echo ${file_name2} >> data_list.txt
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
mkdir mc_runs
i=0
if [ ${input_dir}/MC/*.root == "${input_dir}/MC/*.root" ]; then
    : ; else
    for file_name in ${input_dir}/MC/*.root; do
        i=$((i+1)) && 
        echo -n ${file_name} > mc_runs/mc_run${i}.txt
        echo ${file_name} >> mc_list.txt
    done;
fi
if [ ${input_dir}/MC/*.txt == "${input_dir}/MC/*.txt" ]; then
    : ; else
    for file_name in ${input_dir}/MC/*.txt; do
        split_file ${file_name} "mc"
    done;
fi
for file_name in ${input_dir}/MC/*; do
    if [ "$(file ${file_name})" == "${file_name}: directory" ] ; then
        if [ ${file_name}/*.root == "${file_name}/*.root" ]; then
            : ; else
            for file_name2 in ${file_name}/*.root; do
                i=$((i+1)) &&
                echo -n ${file_name2} > mc_runs/mc_run${i}.txt
                echo ${file_name2} >> mc_list.txt
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
# rm sfile.txt