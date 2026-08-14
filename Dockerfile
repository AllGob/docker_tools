FROM ubuntu:22.04
MAINTAINER Al Gb
ENV SOFT="/soft"
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
    autoconf \
    automake \
    make \
    gcc \
    perl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libdeflate-dev \
    wget \
    && rm -rf /var/lib/apt/lists/* 
# в один слой все пакеты, которые пригодятся при сборке 