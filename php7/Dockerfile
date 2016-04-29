FROM dr.dontstay.kr/ubuntu:14.04.3-compiler
MAINTAINER jinwoo <jinwoo@yellotravel.com>

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

ENV PHP_VERSION php-7.0.5
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
RUN cd /usr/local/src/$PHP_VERSION && ./buildconf --force && ./configure \
    --enable-mbstring --with-zlib --with-curl --with-iconv --with-freetype-dir --enable-sockets  \
    --enable-opcache --enable-xml \
    --with-libdir=/lib/x86_64-linux-gnu \
    --with-mcrypt --enable-fd-setsize=8192 --enable-fpm --with-config-file-path=/etc/ \
    --with-libdir=lib64 --with-openssl --with-config-file-scan-dir=/etc/php.conf.d --with-pdo-mysql\
    --enable-fpm \
    --with-openssl \
    --with-curl  \
    make -j4 && make install


EXPOSE 80
