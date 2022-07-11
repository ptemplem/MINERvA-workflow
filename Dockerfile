FROM ptemplem/mat-container:latest

### Working Folders
ENV TOPDIR "/MINERvA-workflow"
WORKDIR ${TOPDIR}/CC-CH-pip-ana
ENV SCRIPTS "${TOPDIR}/scripts"

### Copy Files
COPY scripts ${SCRIPTS}

### Clone Analysis
RUN cd ${TOPDIR} && \
    git clone https://github.com/ptemplem/CC-CH-pip-ana

### Setup Scripts
RUN chmod +x ${TOPDIR}/opt/bin/setup_MAT.sh && ${TOPDIR}/opt/bin/setup_MAT.sh
ENV MPARAMFILESROOT ${TOPDIR}/opt/etc/MParamFiles
ENV MPARAMFILES=${MPARAMFILESROOT}/data

RUN root -qbl rootIncludes.C loadLibs.C