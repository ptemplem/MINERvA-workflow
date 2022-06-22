### Dockerfile Reference: Madminer Workflow (https://github.com/madminer-tool/madminer-workflow-ph/blob/master/Dockerfile)
#### Root image
#### Reference: https://github.com/root-project/root-docker/blob/master/ubuntu/Dockerfile
FROM rootproject/root:6.24.00-ubuntu20.04

### Dependencies
RUN apt install cvs

### Setup MAT-MINERvA
RUN git clone https://github.com/MinervaExpt/MAT-MINERvA.git \
    && mkdir -p opt/build && cd opt/build \
    && cmake ../../MAT-MINERvA/bootstrap -DCMAKE_INSTALL_PREFIX=`pwd`/.. -DCMAKE_BUILD_TYPE=Release \
    && make install

### Clone CC-CH-pip-ana (forked from original)
RUN cd ${TOPDIR} \
    && git clone https://github.com/ptemplem/CC-CH-pip-ana

### Working Folders
ENV TOPDIR "/MINERvA-workflow"

### Copy Files
COPY scripts ${TOPDIR}/scripts
COPY data ${TOPDIR}/data

### Set workdir
WORKDIR ${TOPDIR}

### Setup Scripts
RUN cd ${TOPDIR}/CC-CH-pip-ana
RUN source ../opt/bin/setup.sh