#########
# Tasks #
#########

.PHONY: publish-to-nexus
publish-to-nexus:
	@python3 -m venv .env
	@( \
		. $(PYTHON_BIN)/activate; \
		poetry config repositories.nexus $(NEXUS_URL); \
		poetry publish -r nexus --username $(NEXUS_USERNAME) --password $(NEXUS_PASSWORD) --build; \
	)

.PHONY: publish-to-pypi
publish-to-pypi:
	@python3 -m venv .env
	@( \
		. $(PYTHON_BIN)/activate; \
		poetry publish --username $(PYPI_USERNAME) --password $(PYPI_PASSWORD) --build; \
	)

.PHONY: dev-setup
dev-setup: ## Setup the local development environment with python3 venv and project dependencies.
	python3 -m venv .env
	( \
		. $(PYTHON_BIN)/activate; \
	     python3 -m pip install --upgrade pip; \
		 pip install poetry; \
		 poetry install --no-root --only dev; \
	)

.PHONY: deploy-release
deploy-release:
	python3 -m venv .env
	( \
		. $(PYTHON_BIN)/activate; \
		pip3 install --upgrade pip; \
		pip install poetry; \
		poetry install --no-root; \
		git config --global user.name "semantic-release (via Azure Pipeline)"; \
		git config --global user.email "semantic-release@azure-pipeline"; \
		semantic-release publish; \
	)

###############
# Definitions #
###############

PYTHON_BIN ?= .env/bin