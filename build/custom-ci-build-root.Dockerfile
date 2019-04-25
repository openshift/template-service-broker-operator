FROM openshift/origin-release:golang-1.10

RUN yum install -y epel-release \
    && yum install -y python-devel python-pip gcc

RUN pip install -U setuptools && pip install molecule==2.20.1 jmespath 'openshift>=8.0.0, < 9.0.0'


RUN chmod g+rw /etc/passwd
