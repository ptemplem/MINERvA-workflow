SHELL := /bin/bash
export DOCKER_USER := "ptemplem"
YADAGE_WORK_DIR = "$(PWD)/yadage-workdir"
export REANA_WORKON := minerva-workflow

.PHONY: build
build:
	@if [$$DOCKER_USER == ""]; then echo "Docker username:" && read DOCKER_USER; fi && \
	echo "Building Docker image..." && \
	docker build . -f Dockerfile -t $(DOCKER_USER)/minerva-workflow --no-cache && \
	echo "Pushing to DockerHub" && \
	docker push $(DOCKER_USER)/minerva-workflow

.PHONY: qbuild
qbuild:
	@if [$$DOCKER_USER == ""]; then echo "Docker username:" && read DOCKER_USER; fi && \
	echo "Building Docker image..." && \
	docker build . -f Dockerfile -t $(DOCKER_USER)/minerva-workflow && \
	echo "Pushing to DockerHub" && \
	docker push $(DOCKER_USER)/minerva-workflow
	
.PHONY: run
run:
	@echo "REANA Token:" && \
	export REANA_SERVER_URL=https://reana.cern.ch && \
	if [$$REANA_ACCESS_TOKEN == ""]; then read -s REANA_ACCESS_TOKEN; fi && \
	echo "Running on REANA..." && \
	reana-client create -n $$REANA_WORKON -t $$REANA_ACCESS_TOKEN && \
	reana-client upload -t $$REANA_ACCESS_TOKEN && \
	reana-client start -t $$REANA_ACCESS_TOKEN

.PHONY: local
local:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/workflow.yml" \
		-p data="anatuples/Data/*" \
		-p mc="anatuples/MC/*" \
		-p do_truth="'false'" \
		-p do_systematics="'false'" \
		-p signal_def="0" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)

.PHONY: test
test:
	@echo "Testing Workflow..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/test.yml" \
		-p do_truth="'true'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)