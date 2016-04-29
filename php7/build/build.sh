#!/bin/bash
BASE_IMAGE="dr.dontstay.kr/ubuntu:14.04.3-compiler"

PHP_VERSION=${PHP_VERSION:-"php-7.0.5"}
NGINX_VERSION=${NGINX_VERSION:-"nginx-1.7.9"}
libmcrypt_VERSION=${libmcrypt_VERSION:-"libmcrypt-2.5.8"}
PHP_LIB=${PHP_LIB:="redis-2.2.5 xdebug-2.2.6 mongo-1.6.11"}

docker run -v ${PWD}/compile.sh:/usr/local/compile.sh  \
           -v ${PWD}/source_dir:/usr/local/src \
           -v ${PWD}/../conf:/usr/local/conf -it ${BASE_IMAGE}\
              /usr/local/compile.sh

rm -rf source_dir/*
docker ps -l
