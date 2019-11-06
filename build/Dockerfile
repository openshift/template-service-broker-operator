FROM quay.io/operator-framework/ansible-operator:master

LABEL com.redhat.delivery.appregistry=true

USER 0
RUN if [[ -f "/usr/local/bin/user_setup" ]] ; then /usr/local/bin/user_setup ; fi
USER 1001

ADD deploy/olm-catalog/openshift-template-service-broker-manifests /manifests

COPY roles/template-service-broker /opt/ansible/roles/template-service-broker
COPY playbook.yaml /opt/ansible/playbook.yaml
COPY watches.yaml /opt/ansible/watches.yaml
