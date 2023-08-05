#!/bin/bash

gcc /server/server.c -lfcgi -o /server/server
service nginx start
spawn-fcgi -p 8080 server/server

while [ 1 ] 
do
one=1
done
