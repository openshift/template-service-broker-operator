FROM openshift/origin-release:golang-1.10

RUN yum install -y epel-release \
    && yum install -y python-devel python-pip gcc

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl \
 && install kubectl /usr/local/bin/kubectl \
 && rm -f kubectl

RUN pip install -U setuptools wheel \
 && pip install molecule==2.20.1 jmespath 'openshift>=0.8.0, < 0.9.0' \
 && pip install -U requests
