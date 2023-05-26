FROM centos:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE aria2
RUN cd /etc/yum.repos.d/ && \
    sudo sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/*.repo && \
    yum repolist && \
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

RUN rpmdev-setuptree && dnf download --source $PACKAGE && rpm -ivh *.rpm
RUN cd ~/rpmbuild/ && ls SOURCES/ && ls SPECS/ && cd SPECS/ && yum-builddep *.spec && rpmbuild -ba *.spec
