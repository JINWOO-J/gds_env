#
# - Base nginx
#
FROM ubuntu:14.04
MAINTAINER JINWOO <jinwoo@yellotravel.com>

#
# Prepare the container
#
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

ENV NGINX_VERSION nginx-1.11.0
ENV DOCKERIZE_VERSION v0.2.0

ENV NGINX_EXTRA_CONFIGURE_ARGS --sbin-path=/usr/sbin \ 
                                --conf-path=/etc/nginx/nginx.conf \
                                --with-md5=/usr/lib --with-sha1=/usr/lib \
                                --with-http_ssl_module --with-http_dav_module \
                                --without-mail_pop3_module --without-mail_imap_module \
                                --without-mail_smtp_module
                             
ENV PHP_INI_DIR /etc/php


ENV NGINX_BUILD_DEPS bzip2 \
		file \
		libbz2-dev \
		libcurl4-openssl-dev \
		libmcrypt-dev \
		libreadline6-dev \
        openssl \
		libssl-dev \
		libxslt1-dev \
		libxml2-dev \
        libpcre3 \
        libpcre3-dev \ 
        curl \
        libc6
ENV NGINX_EXTRA_BUILD_DEPS gcc libc-dev make pkg-config  \
                           libxml2 \
                           ca-certificates \
                           autoconf \
                           runit nano less tmux wget git
                             
		
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# RUN apt-get update && apt-get install -y    \
#     $NGINX_BUILD_DEPS $NGINX_EXTRA_BUILD_DEPS \
#     --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y    \
        $NGINX_BUILD_DEPS $NGINX_EXTRA_BUILD_DEPS \
        --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && gpg --keyserver pgpkeys.mit.edu --recv-key A1C052F8 \
	&& mkdir -p /var/log/nginx \
	&& set -x \
	&& curl -SL "http://nginx.org/download/${NGINX_VERSION}.tar.gz" -o nginx.tar.bz2 \
	&& curl -SL "http://nginx.org/download/${NGINX_VERSION}.tar.gz.asc" -o nginx.tar.bz2.asc \
	&& gpg --verify nginx.tar.bz2.asc \
	&& mkdir -p /usr/src/nginx \
	&& tar -xof nginx.tar.bz2 -C /usr/src/nginx --strip-components=1 \
	&& rm nginx.tar.bz2* \
	&& cd /usr/src/nginx \
	&& ./configure \
		$NGINX_EXTRA_CONFIGURE_ARGS \
	&& make -j"$(nproc)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
	&& make clean 	
#	&& apt-get purge --yes --force-yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $NGINX_EXTRA_BUILD_DEPS 


RUN groupadd -r app -g 433 && \
	mkdir /home/app && \
	mkdir -p /var/www/html && \
	useradd -u 431 -r -g app -d /home/app -s /sbin/nologin -c "Docker image user for web application" app && \
	chown -R app:app /home/app /var/www/html && \
	chmod 700 /home/app && \
	chmod 711 /var/www/html

COPY files / 


RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm -f dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz



# RUN cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini
# RUN sh -c "echo 'date.timezone = asia/seoul' >> ${PHP_INI_DIR}/php.ini"
# RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' ${PHP_INI_DIR}/php.ini

#
# Docker properties
#

VOLUME ["/var/www/html", "/etc/nginx"]

EXPOSE 80
EXPOSE 443

CMD ["/run.sh"]
# CMD ["/usr/local/sbin/runsvdir-init"]