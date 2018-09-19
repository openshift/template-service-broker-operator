FROM quay.io/water-hole/ansible-operator

COPY . /opt/ansible/roles/template-service-broker
COPY deploy.yml /opt/ansible/deploy.yml
COPY watches.yaml /opt/ansible/watches.yaml
