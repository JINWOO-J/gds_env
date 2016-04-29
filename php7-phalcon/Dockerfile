FROM dr.dontstay.kr/ubuntu:14.04.3-compiler
MAINTAINER jinwoo <jinwoo@yellotravel.com>

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list     

# ENV PHP_VERSION php-7.0.5.tar.gz
# ADD http://kr1.php.net/get/$PHP_VERSION/from/this/mirror /usr/local/src
ADD src/php-7.0.5.tar.gz /usr/local/src

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y \
    apache2-mpm-prefork \
    apache2-prefork-dev \
    aufs-tools \
    automake \
    btrfs-tools \
    build-essential \
    curl \
    enchant \
    git \
    libbz2-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libenchant-dev \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg8-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpspell-dev \
    libreadline-dev \
    libsnmp-dev \
    libssl-dev \
    libt1-dev \
    libtidy-dev \
    libvpx-dev \
    libxml2-dev \
    libxslt1-dev \
    mcrypt \
    re2c && \
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

RUN curl -O http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    curl -O http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i bison_2.7.1.dfsg-1_amd64.deb && \
    apt-mark hold libbison-dev && apt-mark hold bison

# Compile PHP7 right now to bootstrap everything else
RUN cd /usr/local/src/php && ./buildconf && ./configure \
    --prefix=/usr/local/php70 \
    --with-config-file-path=/usr/local/php70 \
    --with-config-file-scan-dir=/usr/local/php70/conf.d \
    --with-apxs2=/usr/bin/apxs2 \
    --with-libdir=/lib/x86_64-linux-gnu \
    --enable-fpm \
    --without-pear \
    --with-openssl \
    --with-curl && \
    make && make install


EXPOSE 80
