#!/bin/sh

# Set location (must be a valid geofabrik location -> https://download.geofabrik.de/)
# Use "planet" to generate tiles of the whole world but make sure you have 85 GB of drive storage and a powerful CPU first!
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
# Start tileservergl
/usr/src/app/docker-entrypoint.sh