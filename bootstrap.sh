#!/bin/sh

# Get Planetiler file (if we don't have it)
if [ ! -f /planetiler.jar ];then
  wget https://github.com/onthegomap/planetiler/releases/latest/download/planetiler.jar
fi
# Generate mbtiles using Planetiler (if we don't have it)
if [ ! -f /data/tennessee.mbtiles ];then
  java -Xmx1g -XX:MaxHeapFreeRatio=40 -jar planetiler.jar --area=tennessee --mbtiles=/data/tennessee.mbtiles --download --force
fi
# Run tileserver-gl with the output file
/usr/src/app/docker-entrypoint.sh --mbtiles /data/tennessee.mbtiles
# echo "RUNNING NGINX3"
# nginx -c /etc/nginx/sites-available/default -g 'daemon off;'
# echo "NGINX RAN"