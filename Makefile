# Build and tag JoshuaMulliken/stable-diffusion
APP_NAME=stable-diffusion
VERSION=0.0.1
DOCKER_REPO=ghcr.io/joshuamulliken

D_FLAGS:=--platform=linux/x86_64

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build $(D_FLAGS) -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache $(D_FLAGS) -t $(APP_NAME) .

run: ## Run container
	docker run -i -t --rm --name="$(APP_NAME)" $(APP_NAME)


up: build run ## Run container

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to Docker Hub

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to Docker Hub

publish-latest: tag-latest ## Publish the `latest` taged container to Docker Hub
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to Docker Hub
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# HELPERS

version: ## Output the current version
	@echo $(VERSION)