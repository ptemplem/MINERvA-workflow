SHELL := /bin/bash
export DOCKER_USER := ptemplem
export REANA_ACCESS_TOKEN := 
export REANA_SERVER_URL := https://reana.cern.ch
YADAGE_WORK_DIR = "$(PWD)/yadage-workdir"
export REANA_WORKON := minerva-workflow-neutrino

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

.PHONY: stop
stop:
	@if [ "$$REANA_ACCESS_TOKEN" == "" ]; then echo "REANA Token:" && read -s REANA_ACCESS_TOKEN; fi && \
	echo "Terminating workflow..." && \
	reana-client stop -t $$REANA_ACCESS_TOKEN --force

.PHONY: results
results:
	@if [ "$$REANA_ACCESS_TOKEN" == "" ]; then echo "REANA Token:" && read -s REANA_ACCESS_TOKEN; fi && \
	echo "Downloading results" && \
	reana-client download plot/*.png
	
.PHONY: local
local:
	@echo "Launching Yadage..."
	@sudo rm -rf yadage-workdir
	@yadage-run $(YADAGE_WORK_DIR) "workflow/workflow.yml" \
		-p data="anatuples/Data_test/*" \
		-p mc="anatuples/MC_test/*" \
		-p do_truth="'false'" \
		-p do_systematics="'false'" \
		-p mc_size="'2'" \
		-p signal_def="0" \
		-p w_exp="'1.4'" \
		-p npi="'1'" \
		-p pim="'0'" \
		-p pi0="'0'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)

.PHONY: test
test:
	@echo "Crating Plots..."
	@sudo rm -rf plot-workdir
	@yadage-run $(PWD)/plot-workdir "workflow/test.yml" \
		-p histograms=yadage-workdir/mc_histograms_0/mc_histogram1.root \
		-p data_runs=yadage-workdir/split_anatuples/data_runs/ \
		-p mc_runs=yadage-workdir/split_anatuples/mc_runs/ \
		-p data=anatuples/Data -p mc=anatuples/MC \
		-p do_truth="'true'" -p do_systematics="'true'" -p signal_def="0" \
		-p w_exp="'1.4'" -p npi="'3'" -p pim="'1'" -p pi0="'1'" \
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

.PHONY: plot
plot:
	@echo "Crating Plots..."
	@sudo rm -rf plot-workdir
	@yadage-run $(PWD)/plot-workdir "workflow/plot.yml" \
		-p histograms=yadage-workdir/merge/histograms.root \
		-p data_runs=yadage-workdir/split_anatuples/data_runs/ \
		-p mc_runs=yadage-workdir/split_anatuples/mc_runs/ \
		-p data=anatuples/Data -p mc=anatuples/MC \
		-p do_truth="'true'" -p do_systematics="'true'" -p signal_def="0" \
		-p w_exp="'1.4'" -p npi="'3'" -p pim="'1'" -p pi0="'1'" \
		-d initdir=$(PWD) \
		--toplevel $(PWD)

.PHONY: root
root:
	@echo "Opening Container..."
	@docker run --rm -ti -v $(PWD)/yadage-workdir:/home/ $(DOCKER_USER)/minerva-workflow:latest				