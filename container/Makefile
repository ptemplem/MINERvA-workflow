DOCKER_USER = "ptemplem"
.PHONY: download
download:
	@git clone https://github.com/MinervaExpt/MAT-MINERvA.git && \
	mkdir -p opt/build && cd opt/build && \
    cmake ../../MAT-MINERvA/bootstrap -DCMAKE_INSTALL_PREFIX=`pwd`/.. -DCMAKE_BUILD_TYPE=Release && \
	make MATFluxAndReweightFiles && \
	make MParamFiles
.PHONY: build
build:
	@docker build -f Dockerfile -t $(DOCKER_USER)/mat-container
.PHONY: push
push:
	@docker push $(DOCKER_USER)/mat-container