#
# - Base nginx / php-fpm image
#
FROM ubuntu:14.04
MAINTAINER JINWOO <jinwoo@yellotravel.com>

#
# Prepare the container
#
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

ENV PHP_VERSION 7.0.6
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=app --with-fpm-group=app --with-curl --with-iconv \
                         --with-libdir=lib64 --with-openssl --with-config-file-scan-dir --enable-opcache \
                         --with-gd \
                         --with-mysql \
                         --with-mysqli \
                         --with-pdo-mysql \
                         --enable-sockets 
                         
ENV PHP_INI_DIR /etc/php

ENV PHP_BUILD_DEPS bzip2 \
		file \
		libbz2-dev \
		libcurl4-openssl-dev \
		libjpeg-dev \
		libmcrypt-dev \
		libpng12-dev \
		libreadline6-dev \
		libssl-dev \
		libxslt1-dev \
		libxml2-dev \
		mysql-client \
		libmysqlclient-dev
		
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y ca-certificates curl libxml2 autoconf \
    gcc libc-dev make pkg-config  \
    runit nano less tmux wget git \
    $PHP_BUILD_DEPS $PHP_EXTRA_BUILD_DEPS \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

ENV PHP7_KEY "1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3"
ENV PHP5_KEY "6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 0BD78B5F97500D450838F95DFE857D9A90D90EC1"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys $PHP7_KEY \
	&& mkdir -p $PHP_INI_DIR/conf.d \
	&& set -x \
	&& curl -SL "http://php.net/get/php-$PHP_VERSION.tar.bz2/from/this/mirror" -o php.tar.bz2 \
	&& curl -SL "http://php.net/get/php-$PHP_VERSION.tar.bz2.asc/from/this/mirror" -o php.tar.bz2.asc \
	&& gpg --verify php.tar.bz2.asc \
	&& mkdir -p /usr/src/php \
	&& tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1 \
	&& rm php.tar.bz2* \
	&& cd /usr/src/php \
	&& ./configure \
    	--sysconfdir="$PHP_INI_DIR" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		$PHP_EXTRA_CONFIGURE_ARGS \
		--disable-cgi \
		--enable-mysqlnd \
		--enable-bcmath \
		--with-bz2 \
		--enable-calendar \
		--with-curl \
		--with-gd \
		--with-jpeg-dir \
		--enable-gd-native-ttf \
		--enable-mbstring \
		--with-mcrypt \
		--with-mysqli \
		--with-pdo-mysql \
		--enable-pcntl \
		--with-openssl \
		--with-xsl \
		--with-readline \
		--with-zlib \
		--enable-zip \
	&& make -j"$(nproc)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps \
	&& make clean \
	&& cd /opt \
	&& curl -sS https://getcomposer.org/installer | php \
	&& ln -s /opt/composer.phar /usr/local/bin/composer

RUN groupadd -r app -g 433 && \
	mkdir /home/app && \
	mkdir -p /var/www/html && \
	useradd -u 431 -r -g app -d /home/app -s /sbin/nologin -c "Docker image user for web application" app && \
	chown -R app:app /home/app /var/www/html && \
	chmod 700 /home/app && \
	chmod 711 /var/www/html

COPY files / 

RUN cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini
RUN sh -c "echo 'date.timezone = asia/seoul' >> ${PHP_INI_DIR}/php.ini"
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' ${PHP_INI_DIR}/php.ini

#
# Docker properties
#

VOLUME ["/var/www/html", "/etc/nginx"]

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/sbin/runsvdir-init"]