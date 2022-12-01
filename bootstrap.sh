#!/bin/sh

# # Get Planetiler file
# wget https://github.com/onthegomap/planetiler/releases/latest/download/planetiler.jar
# # Generate mbtiles using Planetiler
# java -Xmx1g -XX:MaxHeapFreeRatio=40 -jar planetiler.jar --area=tennessee --mbtiles=/data/tennessee.mbtiles --download --force
# # Run tileserver-gl with the output file
# /usr/src/app/docker-entrypoint.sh --mbtiles /data/tennessee.mbtiles
echo "RUNNING NGINX3"
nginx -c /etc/nginx/sites-available/default -g 'daemon off;'
echo "NGINX RAN"