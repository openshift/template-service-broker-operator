REGISTRY   ?= docker.io
ORG        ?= automationbroker
TAG        ?= $(shell git rev-parse --short HEAD)
IMAGE      ?= ${REGISTRY}/${ORG}/template-service-broker-operator:${TAG}
NAMESPACE  ?= openshift-template-service-broker

build: ## Build the tsb operator image
	operator-sdk build ${IMAGE}

deploy: ## Deploy the tsb operator image in cluster
	sed 's|REPLACE_IMAGE|${IMAGE}|g; s|REPLACE_NAMESPACE|${NAMESPACE}|g; s|Always|IfNotPresent|' \
		deploy/namespace.yaml deploy/rbac.yaml deploy/operator.yaml \
		deploy/crds/osb_v1alpha1_templateservicebroker_crd.yaml \
		deploy/crds/osb_v1alpha1_templateservicebroker_cr.yaml | \
		kubectl create -f -

undeploy: ## UnDeploy the tsb operator image in cluster
	sed 's|REPLACE_IMAGE|${IMAGE}|g; s|REPLACE_NAMESPACE|${NAMESPACE}|g; s|Always|IfNotPresent|' \
		deploy/crds/osb_v1alpha1_templateservicebroker_cr.yaml \
		deploy/crds/osb_v1alpha1_templateservicebroker_crd.yaml \
		deploy/operator.yaml deploy/rbac.yaml deploy/namespace.yaml | \
		kubectl delete -f -

openshift-ci-test-container:
	yum -y install ansible-lint
	mkdir -p /opt/ansible/roles/
	cp -r roles/template-service-broker /opt/ansible/roles/template-service-broker
	cp -r watches.yaml /opt/ansible/watches.yaml
	cp -r playbook.yaml /opt/ansible/playbook.yaml

openshift-ci-operator-lint:
	ANSIBLE_LOCAL_TEMP=/tmp/.ansible ansible-lint /opt/ansible/playbook.yaml

.PHONY: build deploy undeploy openshift-ci-test-container openshift-ci-operator-lint
