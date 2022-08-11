# REANA Workflow for the CC Pion MINERvA Analysis
A yadage workflow based on Ben Messerly's CC Pion Analysis (https://github.com/MinervaExpt/CC-CH-pip-ana). Software dependencies (including those from MAT and MAT-MINERvA) are accessed using a Docker container. The workflow can be run localy for testing, but is intended to be run with REANA on a computing cluster.

This workflow is my project as an IRIS-HEP Summer Fellow (see https://iris-hep.org/fellows/ptemplem.html).
## Installation
To access the workflow, just clone this git repo: 
```
git clone https://github.com/ptemplem/MINERvA-workflow.git
```

Then, install the reana-client python package to enable running the workflow (will also install yadage, the workflow language). It is recommended you do this in a virtual environment (see https://reana.io/):
```
virtualenv ~/.virtualenvs/myreana
source ~/.virtualenvs/myreana/bin/activate
pip install reana-client
```
You will also need a CERN account to get a CERN REANA access token. If you're using a different REANA cluster, you can change the server url in the Makefile.
# Usage
1. Add your input "anatuples" to the corresponding `anatuples/Data` and `anatuples/MC` folders. These should be in the form of .txt files with XRootD links to the .root files. Each .txt file will be interpreted as a playlist for purposes of scheduling the workflow.
2. Set workflow parameters. These can be found in the `reana.yml` file. Ensure all parameters are passed as strings (the way the file is currently formated), otherwise the workflow may break. If you're testing locally, you'll need to set the parameters by editing the scripts in the Makefile.
3. Type `make run` to run the full workflow on REANA.
4. Monitor workflow progress at https://reana.cern.ch/ and download results with `make results`.
## Editing the analysis
If you want to edit the analysis or any of the script files, you will need to rebuild the Docker container. Of course, you will need to install Docker on your system to do this (see https://docs.docker.com/engine/install/). Then, follow these steps:
1. Clone your updated analysis to a directory named `CC-CH-pip-ana` located in the `MINERvA-workflow` directory. I'm using a fork of Ben Messerly's CC Pion Analysis where I have altered the inputs to the ROOT macros (https://github.com/ptemplem/CC-CH-pip-ana).
2. Update the DOCKER_USER variable in the Makefile to your Docker username, and run `make build` to build and push your new Docker image (this won't take too long as it mostly just recompiles the analysis's C++ files).
3. Update the Docker image name line 3 of workflow/yadage/steps.yml to match yours (the format should be 'username'/minerva-workflow).

If you want to test this locally before sending it off to REANA, you can run `make local`. Make sure you only use a small sample of input files, as you don't have REANA's computing power.
