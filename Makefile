REGISTRY   ?= docker.io
ORG        ?= automationbroker
TAG        ?= $(shell git rev-parse --short HEAD)
IMAGE      ?= ${REGISTRY}/${ORG}/template-service-broker-operator:${TAG}

build: ## Build the tsb operator image
	docker build -t ${IMAGE} -f build/Dockerfile .

openshift-ci-test-container:
	yum -y install ansible-lint
	mkdir -p /opt/ansible/roles/
	cp -r roles/template-service-broker /opt/ansible/roles/template-service-broker
	cp -r watches.yaml /opt/ansible/watches.yaml
	cp -r playbook.yaml /opt/ansible/playbook.yaml

openshift-ci-operator-lint:
	ANSIBLE_LOCAL_TEMP=/tmp/.ansible ansible-lint /opt/ansible/playbook.yaml

.PHONY: build openshift-ci-test-container openshift-ci-operator-lint
