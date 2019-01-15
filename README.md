Template Service Broker Operator
=======

An operator for managing the Template Service Broker

* Use `IMAGE=docker.io/automationbroker/template-service-broker-operator make deploy`
  will deploy all of the necessary objects for the operator to run in the cluster.
* Use `make deploy-objects` and `make deploy-crds` (and skip deploying the operator)
  if you want to use `operator-sdk up local`.
* Use `make help` if you want help automating some of the development workflows.
