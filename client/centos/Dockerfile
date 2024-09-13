FROM centos:7

COPY motd /etc/motd
COPY ./systemctl /usr/bin/systemctl

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo; \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo; \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo; \
    yum -y update; \
    yum install -y gcc python3 python3-pip openssh-server glibc-common; \
    yum clean all

RUN yum install -y openssh-server sudo
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce git \
    && sed -i -e '4d;5d;8d' /lib/systemd/system/docker.service \
    && yum clean all

RUN curl -Lf -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && curl -Lf -o /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/bin/jq /usr/bin/docker-compose 

COPY ./docker.service /usr/lib/systemd/system/

RUN useradd admin -m -G wheel
RUN echo 'admin:admin' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

WORKDIR /root
EXPOSE 22 80

# Setup certs and ssh keys
RUN mkdir -p /var/run/pwd/certs && mkdir -p /var/run/pwd/uploads \
    && ssh-keygen -N "" -t rsa -f  /etc/ssh/ssh_host_rsa_key >/dev/null \
    && mkdir ~/.ssh && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

FROM centos:7

COPY motd /etc/motd
COPY ./systemctl /usr/bin/systemctl

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo; \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo; \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo; \
    yum -y update; \
    yum install -y gcc python3 python3-pip openssh-server glibc-common; \
    yum clean all

RUN yum install -y openssh-server sudo
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce git \
    && sed -i -e '4d;5d;8d' /lib/systemd/system/docker.service \
    && yum clean all

RUN curl -Lf -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && curl -Lf -o /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/bin/jq /usr/bin/docker-compose 

COPY ./docker.service /usr/lib/systemd/system/

RUN useradd admin -m -G wheel
RUN echo 'admin:admin' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

WORKDIR /root
EXPOSE 22 80

# Setup certs and ssh keys
RUN mkdir -p /var/run/pwd/certs && mkdir -p /var/run/pwd/uploads \
    && ssh-keygen -N "" -t rsa -f  /etc/ssh/ssh_host_rsa_key >/dev/null \
    && mkdir ~/.ssh && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

    CMD ["/bin/bash", "-c", "/usr/sbin/sshd -o PermitRootLogin=yes -o PrintMotd=no 2>/dev/null && systemctl start docker && while true; do bash -l; done"]
