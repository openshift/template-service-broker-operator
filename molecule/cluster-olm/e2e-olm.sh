#!/usr/bin/env bash

DIR=${DIR:-$(cd $(dirname "$0")/../../deploy/olm-catalog/openshift-template-service-broker-manifests && pwd)}
VERSION=${VERSION:-4.2}

NAMEDISPLAY=${NAME:-"OpenShift Template Broker Operator"}
NAME=${NAME:-openshift-template-broker-operator}

indent() {
  INDENT="      "
  sed "s/^/$INDENT/" | sed "s/^${INDENT}\($1\)/${INDENT:0:-2}- \1/"
}

CRD=$(cat $(ls $DIR/$VERSION/*crd.yaml) | grep -v -- "---" | indent apiVersion)
CSV=$(cat $(ls $DIR/$VERSION/*version.yaml) | grep -v -- "---" |  indent apiVersion)
PKG=$(cat $(ls $DIR/*package.yaml) | indent packageName)

cat <<EOF | sed 's/^  *$//'
kind: ConfigMap
apiVersion: v1
metadata:
  name: $NAME
data:
  customResourceDefinitions: |-
$CRD
  clusterServiceVersions: |-
$CSV
  packages: |-
$PKG
EOF
