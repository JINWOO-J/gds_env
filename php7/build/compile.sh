#!/bin/bash
## NGINX-PHP compiler  for ubuntu
##
## by jinwoo

#php-fpm -F -y /usr/local/mount/conf/php-fpm.conf


function print_w(){
	RESET='\e[0m'  # RESET
	BWhite='\e[7m';    # backgroud White
	printf "${BWhite} ${1} ${RESET}\n";
}

function PrintOK() {
	IRed='\e[0;91m'         # Rosso
	IGreen='\e[0;92m'       # Verde
	RESET='\e[0m'  # RESET
    MSG=${1}
    CHECK=${2:-0}

    if [ ${CHECK} == 0 ];
    then
        printf "${IGreen} [OK] ${CHECK}  ${MSG} ${RESET} \n"
    else
        printf "${IRed} [FAIL] ${CHECK}  ${MSG} ${RESET} \n"
        printf "${IRed} [FAIL] Stopped script ${RESET} \n"
        exit 0;
    fi
}



print_w "START Compling \n"

PHP_VERSION=${PHP_VERSION:-"php-7.0.5"}
NGINX_VERSION=${NGINX_VERSION:-"nginx-1.7.9"}
libmcrypt_VERSION=${libmcrypt_VERSION:-"libmcrypt-2.5.8"}
PHP_LIB=${PHP_LIB:="xdebug-2.4.0 mongodb-1.1.6"}

# NGINX_VERSION="nginx-1.7.9"
# libmcrypt_VERSION="libmcrypt-2.5.8"

print_w "PHP_VERSION   = ${PHP_VERSION} \n"
print_w "NGINX_VERSION = ${NGINX_VERSION} \n"
print_w "PHP_LIB       = ${PHP_LIB}\n"



# print_w "Yum install\n"
#
# yum install -y libxml2-devel openssl-devel libcurl-devel.x86_64 libcurl.x86_64
# yum install -y gcc-c++ pcre-devel bzip2-devel autoconf graphviz  psmisc
# yum install -y python-setuptools
# easy_install supervisor

cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

apt-get update && apt-get install -y \
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


cd /usr/local/src/


print_w "Installing - ${libmcrypt_VERSION} \n"

wget -q http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/${libmcrypt_VERSION}.tar.gz
find ${libmcrypt_VERSION}.tar.gz
PrintOK "Download check ${libmcrypt_VERSION}.tar.gz"

tar zxf ${libmcrypt_VERSION}.tar.gz



pushd ${libmcrypt_VERSION}
./configure   > /dev/null 2>&1
make -j4  > /dev/null 2>&1
make install  > /dev/null 2>&1
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig
popd


#### PHP
print_w "Installing - ${PHP_VERSION} \n"

wget -q --content-disposition  "http://kr1.php.net/get/${PHP_VERSION}.tar.gz/from/this/mirror"
find ${PHP_VERSION}.tar.gz
PrintOK "Download check ${PHP_VERSION}.tar.gz"


mkdir /etc/php.conf.d

tar zxf ${PHP_VERSION}.tar.gz

pushd ${PHP_VERSION}
#
# ./configure  --disable-debug  --enable-opcache --enable-xml --with-libxml-dir=/usr/local/libxml \
# --enable-mbstring --with-zlib --with-curl --with-iconv --with-freetype-dir --enable-sockets  \
# --with-mcrypt --enable-fd-setsize=8192 --enable-fpm --with-config-file-path=/etc/ --with-mysql=/usr/lib64 \
# --with-libdir=lib64 --with-mysql --with-openssl --with-config-file-scan-dir=/etc/php.conf.d --with-pdo-mysql > /dev/null 2>&1


./buildconf --force && ./configure \
    --enable-mbstring --with-zlib --with-curl --with-iconv --with-freetype-dir --enable-sockets  \
    --enable-opcache --enable-xml \
    --with-libdir=/lib/x86_64-linux-gnu \
    --with-mcrypt --enable-fd-setsize=8192 --enable-fpm --with-config-file-path=/etc/ \
    --with-libdir=lib64 --with-openssl --with-config-file-scan-dir=/etc/php.conf.d --with-pdo-mysql\
    --enable-fpm \
    --with-openssl \
    --with-curl > /dev/null 2>&1

#    --with-mysql




PrintOK "PHP ./configure"
make -j4  > /dev/null 2>&1
PrintOK "PHP make"
make install  > /dev/null 2>&1
PrintOK "PHP make install"
popd

## PHP lib
#PHP_LIB="redis-2.2.5 xdebug-2.2.6"



git clone https://github.com/phalcon/zephir
pushd zephir
./bin/zephir compile
popd

git clone http://github.com/phalcon/cphalcon
pushd cphalcon
git checkout 2.1.x
/usr/local/src/zephir/bin/zephir build --backend=ZendEngine3
popd




extension_path=`php -i | grep ^extension_dir | awk '{print $3}'`

for lib in $PHP_LIB
do
	print_w "Installing - PHP lib :: ${lib} \n"
	wget -q http://pecl.php.net/get/${lib}.tgz
	find ${lib}.tgz   # file command는 STDERR가 없다
	PrintOK "Download check  ${lib}.tgz"
	 tar zxf ${lib}.tgz
   	pushd ${lib}
	phpize
	./configure   > /dev/null 2>&1
	PrintOK "PHPLib ${lib} ./configure"
	make -j4    > /dev/null 2>&1
	PrintOK "PHPLib ${lib} make "
	make install    > /dev/null 2>&1
	PrintOK "PHPLib ${lib} make install "

	checkfile=`echo ${lib}| cut -d "-" -f1`
	find "${extension_path}/${checkfile}.so"
	PrintOK "PHPLib file check ${extension_path}/${checkfile}.so"
	popd

done

# Nginx compile
print_w "Installing - ${NGINX_VERSION} \n"

wget -q http://nginx.org/download/${NGINX_VERSION}.tar.gz
file ${NGINX_VERSION}.tar.gz
PrintOK "Download check  ${NGINX_VERSION}.tar.gz"
tar zxf ${NGINX_VERSION}.tar.gz
pushd ${NGINX_VERSION}

./configure --sbin-path=/usr/sbin --conf-path=/etc/nginx/nginx.conf --with-md5=/usr/lib --with-sha1=/usr/lib --with-http_ssl_module --with-http_dav_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module  > /dev/null 2>&1

make -j4 > /dev/null 2>&1
make install   > /dev/null 2>&1

popd

mkdir -p /etc/php-fpm.d/
mkdir -p /var/www/html

cp -vf /usr/local/conf/www.conf /etc/php-fpm.d/
cp -vf /usr/local/conf/php-fpm.conf /etc/
cp -vf /usr/local/conf/php.ini /etc/
cp -vf /usr/local/conf/nginx.conf /etc/nginx/
cp -rf /usr/local/conf/vhost.d etc/nginx/

# yum remove -y gcc-c++ pcre-devel openssl-devel bzip2-devel libxml2-devel libcurl-devel.x86_64 libxslt-devel.x86_64
#yum -y erase gtk2 libX11 hicolor-icon-theme freetype bitstream-vera-fonts
#yum -y erase gtk2 hicolor-icon-theme freetype bitstream-vera-fonts

print_w "Delete to tarball source \n"

print_w "Completed compile \n"

mkdir -p "/var/log/nginx"
touch "/${PHP_VERSION}_${NGINX_VERSION}_$(date +%Y%m%d-%H%M)"
