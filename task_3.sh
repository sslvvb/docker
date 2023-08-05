#!/bin/bash

docker pull nginx
docker run --name task3 -dt -p 81:81 nginx
docker exec -it task3 apt update
docker exec -it task3 apt install -y gcc libfcgi-dev spawn-fcgi make
docker exec -it task3 mkdir /server
cd server
docker cp server.c task3:server/server.c
docker cp Makefile task3:server/Makefile
cd ../nginx
docker cp nginx.conf task3:etc/nginx/nginx.conf
docker exec task3 nginx -s reload
docker exec task3 bash -c 'make server -C /server/'
curl http://localhost:81
