FROM ubuntu:22.04
MAINTAINER Al Gb
ENV SOFT="/soft"
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
    python3 \
    libncurses5-dev \
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
#Везде запуск /make в параллельном режиме на всех ядрах.
# HTSlib 1.22.1 (release 2025-07-14, https://github.com/samtools/htslib)
RUN wget -q https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 && \
    tar -xjf htslib-${HTSLIB_VERSION}.tar.bz2 && \
    cd htslib-${HTSLIB_VERSION} && \
    ./configure --prefix=$SOFT/htslib-${HTSLIB_VERSION} && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    rm -rf htslib-${HTSLIB_VERSION}*
#В этой библиотеке три бинарника, поэтому в переменной окружения добавляю их + сам путь до библиотеки. 
ENV PATH="$SOFT/htslib-${HTSLIB_VERSION}/bin:${PATH}" \
    LD_LIBRARY_PATH="$SOFT/htslib-${HTSLIB_VERSION}/lib:${LD_LIBRARY_PATH}" \
    BGZIP="$SOFT/htslib-${HTSLIB_VERSION}/bin/bgzip" \
    TABIX="$SOFT/htslib-${HTSLIB_VERSION}/bin/tabix" \
    HTSFILE="$SOFT/htslib-${HTSLIB_VERSION}/bin/htsfile"

# samtools 1.22.1 20250714
RUN wget -q https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar -xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure --prefix=$SOFT/samtools-${SAMTOOLS_VERSION} --with-htslib=$SOFT/htslib-${HTSLIB_VERSION} && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    rm -rf samtools-${SAMTOOLS_VERSION}*

ENV PATH="$SOFT/samtools-${SAMTOOLS_VERSION}/bin:${PATH}" \
    SAMTOOLS="$SOFT/samtools-${SAMTOOLS_VERSION}/bin/samtools"

# bcftools 1.22 2025.05.30
RUN wget -q https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    tar -xjf bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${BCFTOOLS_VERSION} && \
    ./configure --prefix=$SOFT/bcftools-${BCFTOOLS_VERSION} --with-htslib=$SOFT/htslib-${HTSLIB_VERSION} && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    rm -rf bcftools-${BCFTOOLS_VERSION}*

ENV PATH="$SOFT/bcftools-${BCFTOOLS_VERSION}/bin:${PATH}" \
    BCFTOOLS="$SOFT/bcftools-${BCFTOOLS_VERSION}/bin/bcftools"

# VCFtools 0.1.17 2025.05,15
RUN wget -q https://github.com/vcftools/vcftools/releases/download/v${VCFTOOLS_VERSION}/vcftools-${VCFTOOLS_VERSION}.tar.gz && \
    tar -xzf vcftools-${VCFTOOLS_VERSION}.tar.gz && \
    cd vcftools-${VCFTOOLS_VERSION} && \
    ./configure --prefix=$SOFT/vcftools-${VCFTOOLS_VERSION} && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    rm -rf vcftools-${VCFTOOLS_VERSION}*

ENV PATH="$SOFT/vcftools-${VCFTOOLS_VERSION}/bin:${PATH}" \
    VCFTOOLS="$SOFT/vcftools-${VCFTOOLS_VERSION}/bin/vcftools" 
