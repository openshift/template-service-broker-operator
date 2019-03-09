FROM alpine as munger

ARG operator_name
ARG broker_name
COPY deploy/olm-catalog/automation-broker-manifests manifests
RUN sed "s,docker.io/automationbroker/template-service-broker-operator:v4.0,$operator_name," -i manifests/0.2.0/templateservicebrokeroperator.v0.2.0.clusterserviceversion.yaml
RUN sed "s,docker.io/openshift/origin-template-service-broker:v4.0,$broker_name," -i manifests/0.2.0/templateservicebrokeroperator.v0.2.0.clusterserviceversion.yaml

FROM quay.io/openshift/origin-operator-registry:latest

COPY --from=munger manifests manifests
RUN initializer

ENTRYPOINT ["registry-server"]
CMD ["-t", "/tmp/termination-log.txt"]

