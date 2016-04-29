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



extension_path=`php -i | grep ^extension_dir | awk '{print $3}'`

for lib in $PHP_LIB
do
	print_w "Installing - PHP lib :: ${lib} \n"
	wget -q -c http://pecl.php.net/get/${lib}.tgz
	find ${lib}.tgz   # file command는 STDERR가 없다
	PrintOK "Download check  ${lib}.tgz" $?
	 tar zxf ${lib}.tgz
   	pushd ${lib}
	phpize
	./configure   > /dev/null 2>&1
	PrintOK "PHPLib ${lib} ./configure" $?
	make -j4    > /dev/null 2>&1
    PrintOK "PHPLib ${lib} make " $?

	make install    > /dev/null 2>&1
	PrintOK "PHPLib ${lib} make install " $?

	checkfile=`echo ${lib}| cut -d "-" -f1`
	find "${extension_path}/${checkfile}.so"
	PrintOK "PHPLib file check ${extension_path}/${checkfile}.so" $?
	popd

done


# yum remove -y gcc-c++ pcre-devel openssl-devel bzip2-devel libxml2-devel libcurl-devel.x86_64 libxslt-devel.x86_64
#yum -y erase gtk2 libX11 hicolor-icon-theme freetype bitstream-vera-fonts
#yum -y erase gtk2 hicolor-icon-theme freetype bitstream-vera-fonts

print_w "Delete to tarball source \n"

print_w "Completed compile \n"

mkdir -p "/var/log/nginx"
touch "/${PHP_VERSION}_${NGINX_VERSION}_$(date +%Y%m%d-%H%M)"
