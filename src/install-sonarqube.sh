#!/bin/bash

IMAGE_NAME=sonarqube
CONTAINER_NAME=sonarqube
H2DB_VOLUME=sonar_H2db
LOGS_VOLUME=sonar_logs
EXT_VOLUME=sonar_ext
TAG=latest
HOST_PORT=9000

sudo docker run --name $CONTAINER_NAME \
    -v $H2DB_VOLUME:/opt/sonarqube/data \
    -v $LOGS_VOLUME:/opt/sonarqube/logs \
    -v $EXT_VOLUME:/opt/sonarqube/extensions \
    -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
    -p $HOST_PORT:9000 \
    -d $IMAGE_NAME:latest

https://docs.docker.com/engine/install/ubuntu/