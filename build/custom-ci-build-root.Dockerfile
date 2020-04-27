FROM openshift/origin-release:golang-1.13

RUN yum install -y epel-release nss_wrapper \
 && yum install -y python36-devel python3-pip gcc

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl \
 && install kubectl /usr/local/bin/kubectl \
 && rm -f kubectl

RUN pip3 install --user 'setuptools<45' wheel~=0.34.2 more-itertools==5.0.0 \
 && pip3 install molecule==2.22 jmespath  'openshift>=0.8.0, < 0.9.0' \
 && pip3 install --user requests~=2.22.0
