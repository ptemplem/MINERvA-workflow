FROM rootproject/root:6.22.08-ubuntu20.04

### Working Folders
ENV TOPDIR "/MINERvA-workflow"
WORKDIR ${TOPDIR}
### MAT-MINERvA Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cvs git && \
    rm -rf /var/lib/apt/lists/*
### Setup MAT-MINERvA
RUN cd ${TOPDIR} && \
    git clone https://github.com/MinervaExpt/MAT-MINERvA.git && \
    mkdir -p opt/build && cd opt/build && \
    cmake ../../MAT-MINERvA/bootstrap -DCMAKE_INSTALL_PREFIX=`pwd`/.. -DCMAKE_BUILD_TYPE=Release && \
    make MAT-MINERvA && \
    make UnfoldUtils
### Copy from build context
COPY MATFluxAndReweightFiles "${TOPDIR}/opt/etc/MATFluxAndReweightFiles"
COPY MParamFiles "${TOPDIR}/opt/etc/MParamFiles"
RUN mkdir -p ${TOPDIR}/opt/lib && ln -s ${TOPDIR}/opt/etc/MATFluxAndReweightFiles ${TOPDIR}/opt/lib/data
### Setup GENIEXSecExtract
RUN git clone https://github.com/MinervaExpt/GENIEXSecExtract.git && \
    mkdir -p opt/buildGENIEXSecExtract && cd opt/buildGENIEXSecExtract && \
    cmake ../../GENIEXSecExtract -DCMAKE_INSTALL_PREFIX=`pwd`/.. -DCMAKE_BUILD_TYPE=Release && \
    make install