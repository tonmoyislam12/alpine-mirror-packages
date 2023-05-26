FROM centos:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE ffmpeg
RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/*.repo && \
    sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/CentOS-Linux-Media.repo && \
    dnf update -y && dnf upgrade -y && mkdir -pv /usr/src/app 

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN dnf --enablerepo=raven-multimedia install -y gcc gcc-c++ \
    libtool libtool-ltdl \
    make cmake wget \
    git epel-release \
    pkgconfig \
    rpmdevtools \
    automake autoconf \
    yum-utils rpm-build && \
    yum clean all

RUN rpmdev-setuptree && wget https://pkgs.dyn.su/el8/multimedia/SRPMS/ffmpeg-6.0-1.el8.src.rpm && rpm -ivh *.rpm
RUN cd ~/rpmbuild/ && ls SOURCES/ && ls SPECS/ && cd SPECS/ && yum-builddep -y *.spec && rpmbuild -ba *.spec
