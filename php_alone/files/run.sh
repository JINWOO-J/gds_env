#!/bin/bash
FPM_LISTEN=${FPM_LISTEN:-"0.0.0.0:9000"}
FPM_USER=${FPM_USER:-"app"}
FPM_GROUP=${FPM_GROUP:-" "}
USE_DOCKERIZE=${USE_DOCKERIZE-"yes"}
PHP_INI_DIR=${PHP_INI_DIR:"/etc/php"}

if [ $USE_DOCKERIZE == "yes" ];
then
    echo "USE the dockerize template";
    dockerize -template /etc/php/php-fpm.tmpl > /etc/php/php-fpm.conf
fi    

source /usr/local/etc/envvars
php-fpm-env > ${PHP_INI_DIR}/php-fpm-env.conf
/usr/local/sbin/php-fpm -c ${PHP_INI_DIR} --nodaemonize

