REGISTRY       ?= docker.io
ORG            ?= automationbroker
TAG            ?= $(shell git rev-parse --short HEAD)
IMAGE          ?= ${REGISTRY}/${ORG}/template-service-broker-operator:${TAG}
NAMESPACE      ?= openshift-template-service-broker
TEMPLATE_CMD    = sed 's|REPLACE_IMAGE|${IMAGE}|g; s|REPLACE_NAMESPACE|${NAMESPACE}|g; s|Always|IfNotPresent|'
DEPLOY_OBJECTS  = deploy/namespace.yaml deploy/service_account.yaml deploy/role.yaml deploy/role_binding.yaml
DEPLOY_OPERATOR = deploy/operator.yaml
DEPLOY_CRDS     = deploy/crds/osb_v1_templateservicebroker_crd.yaml
DEPLOY_CRS      = deploy/crds/osb_v1_templateservicebroker_cr.yaml
ACTION          = create


build: ## Build the tsb operator image
	operator-sdk build ${IMAGE}

$(DEPLOY_OBJECTS) $(DEPLOY_CRDS) $(DEPLOY_OPERATOR) $(DEPLOY_CRS):
	@${TEMPLATE_CMD} $@ | kubectl apply -f -

deploy-objects: $(DEPLOY_OBJECTS) ## Create the operator namespace and RBAC in cluster

deploy-crds: $(DEPLOY_CRDS) ## Create operator's custom resources
	sleep 1

deploy-operator: $(DEPLOY_OPERATOR) ## Deploy the operator

deploy-cr: $(DEPLOY_CRS) ## Create a CR for the operator

deploy: deploy-objects deploy-crds deploy-operator deploy-cr ## Deploy everything for the operator in cluster

undeploy: ## Delete everything for the operator from the cluster
	-${TEMPLATE_CMD} $(DEPLOY_OBJECTS) $(DEPLOY_OPERATOR) $(DEPLOY_CRDS) $(DEPLOY_CRS) | kubectl delete -f -

openshift-ci-test-container:
	yum -y install ansible-lint
	mkdir -p /opt/ansible/roles/
	cp -r roles/template-service-broker /opt/ansible/roles/template-service-broker
	cp -r watches.yaml /opt/ansible/watches.yaml
	cp -r playbook.yaml /opt/ansible/playbook.yaml

openshift-ci-operator-lint:
	echo "default:x:`id -u`:0:Default User:/tmp:/sbin/nologin" >> /etc/passwd
	ANSIBLE_LOCAL_TEMP=/tmp/.ansible ansible-lint /opt/ansible/playbook.yaml

help: ## Show this help screen
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

hello:
	@echo "Hello from template-service-broker-operator"

.PHONY: build $(DEPLOY_OBJECTS) $(DEPLOY_OPERATOR) $(DEPLOY_CRDS) $(DEPLOY_CRS) undeploy openshift-ci-test-container openshift-ci-operator-lint hello
