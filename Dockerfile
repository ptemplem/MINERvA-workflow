FROM ptemplem/mat-container:latest
### Setup Environements
ENV TOPDIR /MINERvA-workflow
WORKDIR ${TOPDIR}/CC-CH-pip-ana
ENV SCRIPTS ${TOPDIR}/scripts

### Copy Files
COPY scripts ${SCRIPTS}
### Clone Analysis
COPY CC-CH-pip-ana ${TOPDIR}/CC-CH-pip-ana

### MAT Includes
ENV PLOTUTILSROOT=${TOPDIR}/opt/lib
ENV LD_LIBRARY_PATH=${PLOTUTILSROOT}:$LD_LIBRARY_PATH

ENV PATH=${TOPDIR}/opt/bin:$PATH
ENV PLOTUTILSTYPE="STANDALONE"
ENV PLOTUTILSVERSION="ROOT6"

ENV ROOT_INCLUDE_PATH=${TOPDIR}/opt/include/PlotUtils:${TOPDIR}/opt/include:${ROOT_INCLUDE_PATH}
ENV MPARAMFILESROOT ${TOPDIR}/opt/etc/MParamFiles
ENV MPARAMFILES=${MPARAMFILESROOT}/data

### Compile Analysis Code
RUN root -b -l loadLibs.C loadMacros.C