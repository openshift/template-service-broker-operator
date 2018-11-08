REGISTRY   ?= docker.io
ORG        ?= automationbroker
TAG        ?= $(shell git rev-parse --short HEAD)
IMAGE      ?= ${REGISTRY}/${ORG}/template-service-broker-operator:${TAG}

build: ## Build the tsb operator image
	docker build -t ${IMAGE} .

openshift-ci-lint:
	yum -y install ansible-lint
	ansible-lint /opt/ansible/main.yml -x ANSIBLE0016 #Fix Me

.PHONY: build openshift-ci-lint
