YADAGE_INPUT_DIR = "$(PWD)"
DATA_DIR = "$(PWD)/anatuples"
MC_DIR = "$(PWD)/anatuples"
YADAGE_SPEC_DIR = "$(PWD)/workflow/yadage"
YADAGE_WORK_DIR = "$(PWD)/yadage-workdir"
DOCKER_USER = "ptemplem"

.PHONY: build
build:
	@echo "Building Docker image..."
	@docker build . -f Dockerfile -t $(DOCKER_USER)/minerva-workflow
	
.PHONY: local
local:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow.yml" \
		-p data=$(DATA_DIR)/*data*.txt \
		-p mc=$(MC_DIR)/*mc*.txt \
		-d initdir=$(YADAGE_INPUT_DIR) \
		--toplevel $(YADAGE_SPEC_DIR)

.PHONY: test
test:
	@echo "Testing Workflow..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "test.yml" \
		-p mc_runs=test/mc_runs/* \
		-d initdir=$(YADAGE_INPUT_DIR) \
		--toplevel $(YADAGE_SPEC_DIR)
