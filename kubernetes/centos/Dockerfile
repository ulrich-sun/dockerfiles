FROM centos:7

COPY ./systemctl /usr/bin/systemctl
COPY ./kubernetes.repo /etc/yum.repos.d/

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo; \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo; \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo; \
    yum -y update;


RUN yum install -y docker-ce \
    && docker-ce-cli \ 
    && containerd.io \
    && docker-buildx-plugin \
    && docker-compose-plugin curl git 

RUN curl -Lf -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && curl -Lf -o /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/bin/jq /usr/bin/docker-compose

ENV VERSION=1.28
RUN curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_7/devel:kubic:libcontainers:stable.repo
RUN curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:${VERSION}/CentOS_7/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo

RUN yum intall -y kubectl-1.29.1 kubeadm-1.29.1 kubelet-1.29.1 \ 
    && cri-o cri-tools

VOLUME ["/var/lib/kubelet"]

COPY ./kubelet.service /usr/lib/systemd/system/
COPY ./10-kubeadm.conf /usr/lib/systemd/system/kubelet.service.d/
COPY ./wrapkubeadm.sh /usr/local/bin/kubeadm
COPY ./tokens.csv /etc/pki/tokens.csv
COPY ./config.toml /etc/containerd/
COPY ./resolv.conf.override /etc/
COPY ./containerd.service /usr/lib/systemd/system/

COPY ./deploy-k8s.sh /etc/kubernetes/
RUN chmod +x /etc/kubernetes/deploy-k8s.sh

COPY motd /etc/motd

RUN echo $'cat /etc/motd \n\
export PS1="[\h \W]$ "' >> /root/.bash_profile

RUN mkdir -p /root/.kube && ln -s /etc/kubernetes/admin.conf /root/.kube/config \
    && rm -f /etc/machine-id

WORKDIR /root

CMD mount --make-shared / && systemctl start containerd && systemctl start kubelet && /bin/bash /etc/kubernetes/deploy-k8s.sh \
    && while true; do bash -l; done