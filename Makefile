SHELL=/bin/bash

## Pull updated Docker images for services in docker-compose.yml
update:
	docker-compose pull

## Create and start containers for services in docker-compose.yml
start:
	docker-compose down --remove-orphans
	docker-compose up --detach

## Stop API and remove containers for services in docker-compose.yml
stop:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	docker-compose down --remove-orphans

## (! DANGEROUS !) Stop API, remove containers, and delete volumes for services in docker-compose.yml (! DANGEROUS !)
clean:
	@read -p "Are you sure you want to clean up? "\
	"Containers, volumes, and instance data will be deleted! [y/N] " response; \
    if [ "$$response" != "y" ]; then \
        echo "Aborted."; \
        exit 1; \
    fi

	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	docker-compose down --remove-orphans --volumes
	rm -rf instance jwks.json sqlite/*

## Start API with a single rq worker
start-api:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	rq worker --url redis://127.0.0.1:6300 &
	stemly run --host 0.0.0.0 --port 5000 --debug --with-threads

## Start API in debug mode with a single rq worker, attached to debugpy
start-api-debug:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 -i :5678 | xargs -r kill

	rq worker --url redis://127.0.0.1:6300 &
	python -m debugpy --listen localhost:5678 --configure-subProcess True \
		-m stemly.cli run --host 0.0.0.0 --port 5000 --debugger

## Start API through Gunicorn with four rq workers
start-api-prod:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	rq worker --url redis://127.0.0.1:6300 &
	rq worker --url redis://127.0.0.1:6300 &
	rq worker --url redis://127.0.0.1:6300 &
	rq worker --url redis://127.0.0.1:6300 &

	gunicorn --bind 0.0.0.0:5000 --workers 4 "stemly.app:create_app()"

## Run unit tests and generate test report (Pytest)
unit-tests:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	python3 -m tox -e py3

## Run integration tests and generate test report (Bats)
integration-tests:
	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	docker-compose down --remove-orphans --volumes
	docker-compose up --detach

	stemly db upgrade

	rq worker --url redis://127.0.0.1:6300 &
	stemly run --host 0.0.0.0 --port 5000 --debug --with-threads &

	sleep 60

	bats -F junit tests/integration/ 2>&1 | tee tests/reports/batsreport.xml

	-pkill --uid ${USER} --full "rq worker"
	-lsof -ti :5000 | xargs -r kill

	docker-compose down --remove-orphans --volumes

## Install pre-commit and add commit hook
pre-commit:
	pip install pre-commit
	pre-commit install

## Run pre-commit against all files
format:
	pre-commit run --all-files

## Run static analysis tools
static-scan:
	trivy fs . | tee trivy_fs.log
	trivy conf . | tee trivy_conf.log

	python3 -m bandit -r . -f csv -o bandit_log.csv -c bandit.yaml -x ./.tox || true

# Self-documenting Makefiles:
# https://gist.github.com/klmr/575726c7e05d8780505a
.DEFAULT_GOAL := show-help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: show-help
show-help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) == Darwin && echo '--no-init --raw-control-chars')
