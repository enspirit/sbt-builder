SHELL=/bin/bash -o pipefail

# Load env vars from optional .env file
 -include .env

# Optional tag version number to use
DOCKER_TAG := $(or ${DOCKER_TAG},${DOCKER_TAG},latest)

default: build push

build:
	docker build -t enspirit/sbt-builder:${DOCKER_TAG} .

push:
	docker push enspirit/sbt-builder:${DOCKER_TAG}
