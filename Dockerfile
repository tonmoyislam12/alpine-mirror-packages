FROM fedora:rawhide
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE aria2
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN dnf install -y gcc gcc-c++ \
    libtool libtool-ltdl \
    make cmake wget \
    git \
    pkgconfig \
    rpmdevtools \
    automake autoconf \
    rpm-build yum-utils && \
    dnf clean all

RUN rpmdev-setuptree && dnf download --source ffmpeg && rpm -ivh *.rpm
RUN cd ~/rpmbuild/ && ls SOURCES/ && ls SPECS/ && cd SPECS/ && dnf builddep -y *.spec && rpmbuild -ba *.spec
