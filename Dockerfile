# Use the official CentOS image as the base
FROM centos:latest
ENV DEBIAN_FRONTEND noninteractive
RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    dnf update -y
    
# Install necessary tools and dependencies
RUN yum update -y && \
    yum install -y wget gcc make rpm-build

# Download the source code of aria2
RUN wget https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.gz && \
    tar xf aria2-1.35.0.tar.gz

# Install additional dependencies for building aria2
RUN yum install -y openssl-devel sqlite-devel expat-devel zlib-devel

# Set the working directory to the extracted aria2 source code
WORKDIR /aria2-1.35.0

# Build and install aria2
RUN ./configure && \
    make && \
    make install

# Create an RPM package of aria2
RUN make package

# Set the working directory to /root, where the RPM package will be generated
WORKDIR /root

# Define the entry point for the Docker container
ENTRYPOINT ["/bin/bash"]
