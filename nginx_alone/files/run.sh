#!/bin/bash
UPSTREAM=${UPSTEAM:-"php_container:9000"}
DOMAIN=${DOMAIN:-"localhost"}
LOCATION=${LOCATION:-" "}
USE_DOCKERIZE=${USE_DOCKERIZE-"yes"}

if [ $USE_DOCKERIZE == "yes" ];
then
    echo "USE the dockerize template";
    dockerize -template /etc/nginx/sites-available/default.tmpl > /etc/nginx/sites-available/default    
fi    

nginx



