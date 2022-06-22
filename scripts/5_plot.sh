# Source: Madminer Workflow
#!/usr/bin/env sh

# The script exits when a command fails or it uses undeclared variables
#set -o errexit
#set -o nounset


# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -i|--histograms)  histograms="$2";    shift  ;;   # Input
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Actions
madd MCinputs.root ${histograms}