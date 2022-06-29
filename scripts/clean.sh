# Source: Madminer Workflow
#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
#set -o errexit
#set -o nounset
rm data_list.txt
rm mc_list.txt
rm -r mc_runs
rm histogram*.root
rm MCXSecInputs.root
rm DataXSecInputs.root

