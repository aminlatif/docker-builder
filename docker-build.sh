#!/bin/bash

if [ -f "./local.env" ]
then
	cat local.env main.env > .env
elif [ -f "../local.env" ]
then
	cat ../local.env main.env > .env
else
	echo "No local.env file exists"
	exit 1
fi

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
mkdir ../vscode-server
if [[ "$COMPOSE_PROFILES" == *"php"* ]]
then
	mkdir ../vscode-server/php
	mkdir ../${DOCKER_PROJECT_DIRECTORY_NAME}
fi
if [[ "$COMPOSE_PROFILES" == *"nodejs"* ]]
then
	mkdir ../vscode-server/nodejs
	mkdir ../${DOCKER_PROJECT_NODEJS_DIRECTORY_NAME}
fi

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

if [ ! -f "./docker-compose.yml" ]
then
	cp ./docker-compose-env.yml ./docker-compose.yml
	env | while IFS= read -r line; do
		value=${line#*=}
		name=${line%%=*}
		printf "Replacing '%s'='%s'\n" "$name" "$value"
		sed -i "s%\${${name}}%${value}%g" ./docker-compose.yml
	done
	sed -i 's%\$%\$\$%g' ./docker-compose.yml
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