FROM centos:7
COPY motd /etc/motd
COPY ./systemctl /usr/bin/systemctl

# Mise à jour des repos et installation des packages
RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo; \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo; \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo; \
    yum -y update; \
    yum install -y gcc python3 python3-pip openssh-server sshpass glibc-common; \
    yum clean all

# Configurer les locales
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV ANSIBLE_VERSION 2.9.1
# Mise à jour de pip et installation d'Ansible
RUN pip3 install --upgrade pip; \
    pip3 install "ansible==${ANSIBLE_VERSION}"

# Configuration utilisateur
RUN useradd admin -G wheel; \
    echo 'admin:admin' | chpasswd; \
    echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

WORKDIR /root
EXPOSE 22 80

# Setup certs and ssh keys
RUN mkdir -p /var/run/pwd/certs && mkdir -p /var/run/pwd/uploads \
    && ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key >/dev/null \
    && mkdir ~/.ssh && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

CMD /usr/sbin/sshd -o PermitRootLogin=yes -o PrintMotd=no 2>/dev/null \
&& while true; do bash -l; done
