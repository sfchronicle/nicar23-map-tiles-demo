#!/bin/sh

# Set location (must be a valid geofabrik location -> https://download.geofabrik.de/)
location="tennessee"

# Get Planetiler file (if we don't have it)
if [ ! -f planetiler.jar ];then
  echo "DOWNLOADING JAR"
  wget https://github.com/onthegomap/planetiler/releases/latest/download/planetiler.jar
fi
# Generate mbtiles using Planetiler (if we don't have it)
if [ ! -f "/data/$location.mbtiles" ];then
  echo "PROCESSING MBTILES"
  java -Xmx1g -XX:MaxHeapFreeRatio=40 -jar planetiler.jar "--area=$location" "--mbtiles=/data/$location.mbtiles" --download --force
fi
# Run tileserver-gl with the output file
echo "SERVING MBTILES"
# Make sure we're in the main folder
cd /
# Create the config to serve all mbtiles and styles
node createconfig.js $location
#/usr/src/app/docker-entrypoint.sh --config /config.json
#/usr/src/app/docker-entrypoint.sh --mbtiles "/data/$location.mbtiles"
/usr/src/app/docker-entrypoint.sh
# echo "RUNNING NGINX3"
# nginx -c /etc/nginx/sites-available/default -g 'daemon off;'
# echo "NGINX RAN"