FROM quay.io/operator-framework/ansible-operator:master

LABEL com.redhat.delivery.appregistry=true

ADD deploy/olm-catalog/openshift-template-service-broker-manifests /manifests

COPY roles/template-service-broker /opt/ansible/roles/template-service-broker
COPY playbook.yaml /opt/ansible/playbook.yaml
COPY watches.yaml /opt/ansible/watches.yaml
