# REANA Workflow for the CC Pion MINERvA Analysis
A yadage workflow based on Ben Messerly's CC Pion Analysis (https://github.com/MinervaExpt/CC-CH-pip-ana). Software dependencies (including those from MAT and MAT-MINERvA) are accessed using a Docker container. The workflow can be run localy for testing, but is intended to be run with REANA on a computing cluster.
Creating this workflow is my project as an IRIS-HEP Summer Fellow (see https://iris-hep.org/fellows/ptemplem.html).
## Installation and Dependencies
To access the workflow, just clone this git repo: `git clone https://github.com/ptemplem/MINERvA-workflow.git`
Install the reana-client python package to allow running the workflow (will also install yadage): `pip install reana-client`
## Usage
**Important functionalities are included as make commands:**
1. `make run`: Runs the full workflow on REANA (not yet implemented).
2. `make local`: Runs the full workflow on the local system with the output directory in the MINERvA-workflow directory.
3. `make build`: Rebuilds the docker image. A pre-built image is already pushed to DockerHub at ptemplem/minerva-workflow. If you need to rebuild it, you will need to push your image to docker hub with `docker push ${DOCKER_USER}/minerva-workflow` and update the image id in line 3 of workflow/yadage/steps.yml
