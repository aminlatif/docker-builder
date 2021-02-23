#!/bin/bash

cat local.env main.env > .env

set -o allexport
source ./.env
set +o allexport


mkdir ../log
mkdir ../extra
mkdir ../settings
mkdir ../settings/php
mkdir ../settings/server
mkdir ../settings/server/apache
mkdir ../settings/msmtp
mkdir ../mysql
mkdir ../mysql/export
mkdir ../mysql/import
mkdir ../${DOCKER_PROJECT_NAME}

if [ ! -f "../settings/php/custom.ini" ]
then
    cp ./php/php-conf/custom.ini ../settings/php
    sed -i "s/{{DOCKER_PROJECT_PHP_MEMORY_LIMIT}}/${DOCKER_PROJECT_PHP_MEMORY_LIMIT}/g" ../settings/php/custom.ini
    sed -i "s/{{DOCKER_PROJECT_NAME}}/${DOCKER_PROJECT_NAME}/g" ../settings/php/custom.ini
    sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}/g" ../settings/php/custom.ini
    sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}/g" ../settings/php/custom.ini
    sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_IDEKEY}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_IDEKEY}/g" ../settings/php/custom.ini
fi

if [ ! -f "../settings/server/apache/000-default.conf" ]
then
    cp ./php/server-conf/apache/000-default.conf ../settings/server/apache
    sed -i "s/{{DOCKER_PROJECT_SERVER_NAME}}/${DOCKER_PROJECT_SERVER_NAME}/g" ../settings/server/apache/000-default.conf
    sed -i "s/{{DOCKER_PROJECT_SERVER_ALIAS}}/${DOCKER_PROJECT_SERVER_ALIAS}/g" ../settings/server/apache/000-default.conf
fi

if [ ! -f "../settings/server/apache/default-ssl.conf" ]
then
    cp ./php/server-conf/apache/default-ssl.conf ../settings/server/apache
    sed -i "s/{{DOCKER_PROJECT_SERVER_NAME}}/${DOCKER_PROJECT_SERVER_NAME}/g" ../settings/server/apache/default-ssl.conf
    sed -i "s/{{DOCKER_PROJECT_SERVER_ALIAS}}/${DOCKER_PROJECT_SERVER_ALIAS}/g" ../settings/server/apache/default-ssl.conf
fi

if [ ! -f "../settings/msmtp/msmtprc" ]
then
    cp ./php/mail-conf/msmtprc ../settings/msmtp
    sed -i "s/{{DOCKER_PROJECT_MAIL_DOMAIN}}/${DOCKER_PROJECT_MAIL_DOMAIN}/g" ../settings/msmtp/msmtprc
    sed -i "s/{{DOCKER_PROJECT_MAIL_SMTP_HOST}}/${DOCKER_PROJECT_MAIL_SMTP_HOST}/g" ../settings/msmtp/msmtprc
    sed -i "s/{{DOCKER_PROJECT_MAIL_SMTP_PORT}}/${DOCKER_PROJECT_MAIL_SMTP_PORT}/g" ../settings/msmtp/msmtprc
    sed -i "s/{{DOCKER_PROJECT_MAIL_USER}}/${DOCKER_PROJECT_MAIL_USER}/g" ../settings/msmtp/msmtprc
    sed -i "s|{{DOCKER_PROJECT_MAIL_PASSWORD}}|${DOCKER_PROJECT_MAIL_PASSWORD}|g" ../settings/msmtp/msmtprc
fi



if [ "$1" = "rebuild" ]
then
	docker-compose -f docker-compose.yml up --build -d 
elif [ "$1" = "force-rebuild" ]
then
	docker-compose -f docker-compose.yml up --build --force-recreate -d
else
	docker-compose -f docker-compose.yml up -d
fi