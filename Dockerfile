FROM centos:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE aria2
RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    dnf update -y && mkdir -pv /usr/src/app 

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN yum update -y && \
    yum install -y gcc gcc-c++ \
    libtool libtool-ltdl \
    make cmake wget \
    git epel-release \
    pkgconfig \
    rpmdevtools \
    automake autoconf \
    yum-utils rpm-build && \
    yum clean all

RUN rpmdev-setuptree && dnf download --source $PACKAGE && rpm -ivh aria2-1.35.0-2.el8.src.rpm && sudo repotrack -a x86_64 -p . aria2-1.35.0-2.el8.src.rpm
RUN cd ~/rpmbuild/ && ls SOURCES/ && ls SPECS/ && cd SPECS/ && rpmbuild -ba *.spec
