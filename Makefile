.PHONY: build
build:
		@echo "Building Docker image..."; \
		@docker build . -f Dockerfile -t minerva-workflow
	
.PHONY: run-local
run-local:
		@echo "Running Workflow in "$(pwd)"/yadage-workdir"
		@rm -rf .yadage && mkdir .yadage
		@yadage-run  $(pwd) "workflow.yml" \
			-p anatuples=$(pwd)/anatuples \
			-d initdir=$(pwd)
			--toplevel $(pwd)/workflow
