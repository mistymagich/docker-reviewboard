#!/bin/bash

# Data Container
docker run -v /.ssh -v /media  --name rb-data busybox true

# MySQL Container
docker run -d --name rb-mysql -e MYSQL_ROOT_PASSWORD=reviewboard mysql

# Memcached Container
docker run --name rb-memcached -d memcached

# Create Database and User
sleep 10 # 
docker run --link rb-mysql:mysql --rm -v "${CURDIR}":/docker mysql \
  sh -c 'MYSQL_PWD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot < /docker/init.sql'


# Build ReviewBoard Container
docker build -t 'mistymagich/reviewboard' git://github.com/mistymagich/docker-reviewboard.git

# ReviewBoard Container
docker run -it --link rb-mysql:mysql --link rb-memcached:memcached --volumes-from rb-data -p 8000:8000 -e DOMAIN="rb.example.com" mistymagich/reviewboard

# After that, go the url 'http://192.168.33.10:8000' or 'http://rb.example.com:8000'
