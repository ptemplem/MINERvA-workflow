### Dockerfile Reference: Madminer Workflow (https://github.com/madminer-tool/madminer-workflow-ph/blob/master/Dockerfile)
FROM rootproject/root:6.24.00-ubuntu20.04

### Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends git

### Clone MAT-MINERvA and CC-CH-pip-ana (forked from original)
RUN git clone https://github.com/MinervaExpt/MAT-MINERvA.git && \
    git clone https://github.com/MinervaExpt/MAT.git && \
    git clone https://github.com/ptemplem/CC-CH-pip-ana

### Working Folders
ENV TOPDIR "/MINERvA-workflow"
WORKDIR ${TOPDIR}/CC-CH-pip-ana
ENV SCRIPTS "${TOPDIR}/scripts"

### Copy Files
COPY scripts ${SCRIPTS}

### Setup Scripts
### RUN bash ${TOPDIR}/opt/bin/setup.sh
RUN root -qbl loadLibs.C++