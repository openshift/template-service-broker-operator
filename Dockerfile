FROM quay.io/operator-framework/ansible-operator:master

COPY roles/template-service-broker /opt/ansible/roles/template-service-broker
COPY main.yml /opt/ansible/main.yml
COPY watches.yaml /opt/ansible/watches.yaml
