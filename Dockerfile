#
FROM fedora:latest

RUN yum install -y glibc-devel glibc-headers glibc-static
RUN yum install -y gcc gcc-c++ cpp pcre-devel
RUN yum install -y openssl-devel zlib-devel
RUN yum install -y cmake make autoconf pkgconfig
RUN yum install -y git mercurial tar wget
RUN yum install -y bzip2 freetype* fontconfig

WORKDIR /opt/vendor
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=https%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"

RUN tar -xvf jdk-8u45-linux-x64.tar.gz
RUN rm jdk-8u45-linux-x64.tar.gz

ENV JAVA_HOME=/opt/vendor/jdk1.8.0_45
ENV JRE_HOME=/opt/vendor/jdk1.8.0_45/jre
ENV PATH=$PATH:/opt/vendor/jdk-8u45-linux-x64/bin:/opt/vendor/jdk1.8.0_45/jre/bin

RUN wget https://nodejs.org/dist/v0.12.4/node-v0.12.4.tar.gz
RUN tar -xvf node-v0.12.4.tar.gz

WORKDIR /opt/vendor/node-v0.12.4
RUN ./configure
RUN make install
RUN npm install -g gulp
RUN npm install -g phantomjs

WORKDIR /opt

ADD ./ /opt/maleficjs

WORKDIR /opt/maleficjs

RUN gulp
