SHELL := /bin/bash
YADAGE_INPUT_DIR = "$(PWD)"
DATA_DIR = "$(PWD)/anatuples/Data"
MC_DIR = "$(PWD)/anatuples/MC"
YADAGE_SPEC_DIR = "$(PWD)/workflow"
YADAGE_WORK_DIR = "$(PWD)/yadage-workdir"
DOCKER_USER = "ptemplem"
export REANA_WORKON := minerva-workflow
.PHONY: build
build:
	@echo "Building Docker image..."
	@docker build . -f Dockerfile -t $(DOCKER_USER)/minerva-workflow --no-cache
	
.PHONY: run
run:
	@echo "REANA Token:" && \
	export REANA_SERVER_URL=https://reana.cern.ch && \
	read -s REANA_ACCESS_TOKEN && \
	echo "Running on REANA..." && \
	reana-client create -n $$REANA_WORKON -t $$REANA_ACCESS_TOKEN && \
	reana-client upload -t $$REANA_ACCESS_TOKEN && \
	reana-client start -t $$REANA_ACCESS_TOKEN

.PHONY: local
local:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/workflow.yml" \
		-p data=$(DATA_DIR)/* \
		-p mc=$(MC_DIR)/* \
		-d initdir=$(YADAGE_INPUT_DIR) \
		--toplevel $(YADAGE_INPUT_DIR)

.PHONY: test
test:
	@echo "Testing Workflow..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/test.yml" \
		-p data=$(DATA_DIR)/* \
		-p mc=$(MC_DIR)/* \
		-d initdir=$(YADAGE_INPUT_DIR) \
		--toplevel $(YADAGE_INPUT_DIR)