#!/bin/bash


set -o allexport
source ./local.env
set +o allexport

set -o allexport
source ./.env
set +o allexport

mkdir ../log
mkdir ../extra
mkdir ../mysql
mkdir ../mysql/export
mkdir ../mysql/import
mkdir ../${DOCKER_PROJECT_NAME}


if [ "$1" = "rebuild" ]
then
	docker-compose -f docker-compose.yml up --build -d 
elif [ "$1" = "force-rebuild" ]
then
	docker-compose -f docker-compose.yml up --build --force-recreate -d
else
	docker-compose -f docker-compose.yml up -d
fi