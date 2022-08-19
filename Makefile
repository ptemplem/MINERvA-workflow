SHELL := /bin/bash
export DOCKER_USER := ptemplem
export REANA_ACCESS_TOKEN := 
export REANA_SERVER_URL := https://reana.cern.ch
YADAGE_WORK_DIR = "$(PWD)/yadage-workdir"
export REANA_WORKON := minerva-workflow

.PHONY: build
build:
	@if [ "$$DOCKER_USER" == "" ]; then echo "Docker username:" && read DOCKER_USER; fi && \
	echo "Building Docker image..." && \
	docker build . -f Dockerfile -t $(DOCKER_USER)/minerva-workflow:latest && \
	echo "Pushing to DockerHub" && \
	docker push $(DOCKER_USER)/minerva-workflow:latest
	
.PHONY: run
run:
	@if [ "$$REANA_ACCESS_TOKEN" == "" ]; then echo "REANA Token:" && read -s REANA_ACCESS_TOKEN; fi && \
	echo "Running on REANA..." && \
	reana-client create -n $$REANA_WORKON -t $$REANA_ACCESS_TOKEN && \
	reana-client upload -t $$REANA_ACCESS_TOKEN && \
	reana-client start -t $$REANA_ACCESS_TOKEN

.PHONY: results
results:
	@if [ "$$REANA_ACCESS_TOKEN" == "" ]; then echo "REANA Token:" && read -s REANA_ACCESS_TOKEN; fi && \
	echo "Downloading results" && \
	reana-client download plots/*.png
	
.PHONY: local
local:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/workflow.yml" \
		-p data="anatuples/Data/*" \
		-p mc="anatuples/MC/*" \
		-p do_truth="'false'" \
		-p do_systematics="'false'" \
		-p by_playlist="'false'" \
		-p signal_def="4" \
		-p w_exp="'1.4'" \
		-p npi="'3'" \
		-p pim="'1'" \
		-p pi0="'1'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)

.PHONY: test
test:
	@echo "Testing Workflow..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/test.yml" \
		-p data="anatuples/Data/*" \
		-p mc="anatuples/MC/*" \
		-p do_truth="'false'" \
		-p do_systematics="'false'" \
		-p by_playlist="'false'" \
		-p signal_def="4" \
		-p w_exp="'1.4'" \
		-p npi="'3'" \
		-p pim="'1'" \
		-p pi0="'1'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)

.PHONY: closure
closure:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/closure.yml" \
		-p data="anatuples/Data/*" \
		-p mc="anatuples/MC/*" \
		-p do_truth="'false'" \
		-p do_systematics="'false'" \
		-p by_playlist="'false'" \
		-p signal_def="0" \
		-p w_exp="'1.4'" \
		-p npi="'3'" \
		-p pim="'1'" \
		-p pi0="'1'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)