# Variables
IMAGE_NAME=mlops-sklearn-project
CONTAINER_NAME=mlops_sklearn_project_container

.PHONY:

default: help

requirements-prod:
	pipenv requirements > ./requirements.txt

requirements-dev:
	pipenv requirements --dev >> ./requirements.txt

requirements: requirements-prod requirements-dev ## Generate requirements.txt from pipenv

lint: ## lint with isort, black, flake8, mypy
	isort --profile black .; black .; flake8 .; mypy .;

build:
	docker build -t $(IMAGE_NAME):latest .

run: ## Run the Docker container
	docker run --name $(CONTAINER_NAME) -d -p 5000:5000 $(IMAGE_NAME):latest

stop: ## Stop the running container
	docker stop $(CONTAINER_NAME)

remove: ## Remove the container
	docker rm $(CONTAINER_NAME)

mlflow-ui: ## Run the MLFlow UI
	mlflow ui

code-run:  ## Run the train script
	python src/train.py

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
