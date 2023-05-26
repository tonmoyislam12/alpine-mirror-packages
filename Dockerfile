FROM fedora:rawhide
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN dnf install -y gcc gcc-c++ \
    libtool libtool-ltdl \
    make cmake wget \
    git rclone \
    pkgconfig \
    rpmdevtools \
    automake autoconf \
    rpm-build yum-utils && \
    dnf clean all
RUN mkdir -pv /.config/rclone && mkdir -pv /root/.config/rclone
RUN curl -L $CONFIG >/.config/rclone/rclone.conf
RUN cp /.config/rclone/rclone.conf /root/.config/rclone/
RUN rpmdev-setuptree && dnf download --source aria2 && rpm -ivh *.rpm
RUN cd ~/rpmbuild/ && ls SOURCES/ && ls SPECS/ && cd SPECS/ && \
    rclone copy *.spec onedriveapi:spec/ && dnf builddep -y *.spec && \
    rpmbuild -ba *.spec
