#base image

FROM centos:7.3.1611 

MAINTAINER Alexey Kuznetsov <kuznetsovalexey34@gmail.com>

#install devtool etc

RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install git
RUN yum -y install maven
RUN yum -y group install "Development Tools"
RUN yum -y install openssl-devel

#install java

ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=161 \
    JAVA_VERSION_BUILD=12 \
    JAVA_URL_HASH=2f38c3b165be4555a1fa6e98c45e0808

RUN wget --no-cookies --no-check-certificate \
  --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjre8-downloads-2133155.html; oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" && \
yum localinstall -y jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm && \
rm -f jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm && \
rm -rf /var/cache/yum

#set password

RUN echo "root:root" | chpasswd

#Install a basic SSH server

RUN yum install -y openssh-server openssh-clients shadow-utils && \
    ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config 


#cleaning

RUN rm -rf /var/cache/yum

#Standard SSH port

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

