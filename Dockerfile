FROM quay.io/water-hole/ansible-operator

COPY roles/template-service-broker /opt/ansible/roles/template-service-broker
COPY main.yml /opt/ansible/main.yml
COPY watches.yaml /opt/ansible/watches.yaml
COPY Makefile /Makefile
