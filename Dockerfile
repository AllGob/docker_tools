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
    bzip2 \
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
ENV HTSLIB_VERSION=1.22.1 \
    SAMTOOLS_VERSION=1.22.1 \
    BCFTOOLS_VERSION=1.22 \
    VCFTOOLS_VERSION=0.1.17
#Уточнил у ИИ, чтобы он проверил по форумам на предмет совместимости версий. Является наиболее оптимальным решением с точки зрения новизны/соместмости. 
WORKDIR /tmp
# HTSlib 1.22.1 
RUN wget -q https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 && \
    tar -xjf htslib-${HTSLIB_VERSION}.tar.bz2 && \
    cd htslib-${HTSLIB_VERSION} && \
    ./configure --prefix=$SOFT/htslib-${HTSLIB_VERSION} && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    rm -rf htslib-${HTSLIB_VERSION}*

