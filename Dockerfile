FROM rootproject/root:6.24.00-ubuntu20.04

### Working Folders
ENV TOPDIR "/MINERvA-workflow"
WORKDIR ${TOPDIR}/CC-CH-pip-ana
ENV SCRIPTS "${TOPDIR}/scripts"

### Copy Files
COPY scripts ${SCRIPTS}

### Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    cvs

### Clone MAT-MINERvA and CC-CH-pip-ana (forked from original); setup MAT-MINERvA
RUN cd ${TOPDIR} && \
    git clone https://github.com/ptemplem/CC-CH-pip-ana
RUN cd ${TOPDIR} && \
    git clone https://github.com/MinervaExpt/MAT-MINERvA.git && \
    mkdir -p opt/build && cd opt/build && \
    cmake ../../MAT-MINERvA/bootstrap -DCMAKE_INSTALL_PREFIX=`pwd`/.. -DCMAKE_BUILD_TYPE=Release && \
    make MAT-MINERvA

### Setup Scripts
RUN root -qbl rootIncludes.C loadLibs.C