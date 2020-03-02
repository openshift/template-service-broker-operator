FROM openshift/origin-release:golang-1.10

RUN yum install -y epel-release \
    && yum install -y python-devel python-pip gcc

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl \
 && install kubectl /usr/local/bin/kubectl \
 && rm -f kubectl

RUN pip install -U setuptools wheel \
 && pip install molecule==2.20.1 jmespath 'openshift>=0.8.0, < 0.9.0' \
 && pip install -U requests

ENV USER_UID=1001 \
    USER_NAME=ansible-operator\
    HOME=/opt/ansible

# Ensure directory permissions are properly set
RUN echo "${USER_NAME}:x:${USER_UID}:0:${USER_NAME} user:${HOME}:/sbin/nologin" >> /etc/passwd
RUN mkdir -p ${HOME}/.ansible/tmp \
 && chown -R ${USER_UID}:0 ${HOME} \
 && chmod -R ug+rwx ${HOME}
