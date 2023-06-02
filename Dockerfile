FROM ptemplem/mat-container:latest
### Setup Environements
ENV TOPDIR /MINERvA-workflow
WORKDIR ${TOPDIR}/CC-CH-pip-ana
ENV SCRIPTS ${TOPDIR}/scripts

### Install Packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    file && \
    rm -rf /var/lib/apt/lists/*

### MAT Include Paths
ENV PLOTUTILSROOT=${TOPDIR}/opt/lib
ENV GENIEXSECEXTRACTROOT=${TOPDIR}/opt/lib
ENV LD_LIBRARY_PATH=${PLOTUTILSROOT}:includes:xsec:${TOPDIR}/scripts:$LD_LIBRARY_PATH

ENV PATH=${TOPDIR}/opt/bin:$PATH
ENV PLOTUTILSTYPE="STANDALONE"
ENV PLOTUTILSVERSION="ROOT6"

ENV ROOT_INCLUDE_PATH=${TOPDIR}/opt/include/PlotUtils:${TOPDIR}/opt/include:${ROOT_INCLUDE_PATH}
ENV MPARAMFILESROOT ${TOPDIR}/opt/etc/MParamFiles
ENV MPARAMFILES=${MPARAMFILESROOT}/data

### Clone Includes
COPY CC-CH-pip-ana/includes ${TOPDIR}/CC-CH-pip-ana/includes
COPY CC-CH-pip-ana/loadLibs.C  ${TOPDIR}/CC-CH-pip-ana
### Compile Includes
RUN root -b -l loadLibs.C

### Clone Remaining Code
COPY CC-CH-pip-ana ${TOPDIR}/CC-CH-pip-ana
### Compile Macros
RUN root -b -l loadLibs.C loadMacros.C

### Stop xrootd Timeout
ENV XRD_STREAMTIMEOUT=18000
ENV XRD_REQUESTTIMEOUT=18000
### Scripts
COPY scripts ${SCRIPTS}