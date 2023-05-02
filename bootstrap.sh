#!/bin/sh

### We are commenting out the Planetiler piece and expecting the tiles to be uploaded
# Set location (must be a valid geofabrik location -> https://download.geofabrik.de/)
# Use "planet" to generate tiles of the whole world but make sure you have 85 GB of drive storage and a powerful CPU first!
# location="tennessee"
cd /data
# Get planet data if we don't have it
if [ ! -f /data/planet.mbtiles ];then
  echo "DOWNLOADING PLANET FRESH"
  wget --timeout=0 --waitretry=0 --tries=5 --retry-connrefused https://sfc-project-files.s3.amazonaws.com/planet.mbtiles
  echo "FINISHED DOWNLOAD"
else
  echo "DOWNLOADING PLANET CONTINUE"
  wget --continue --timeout=0 --waitretry=0 --tries=5 --retry-connrefused https://sfc-project-files.s3.amazonaws.com/planet.mbtiles
  echo "FINISHED DOWNLOAD"
fi

# # Generate mbtiles using Planetiler (if we don't have it)
# if [ ! -f "/data/$location.mbtiles" ];then
#   echo "PROCESSING MBTILES"
#   java -Xmx1g -XX:MaxHeapFreeRatio=40 -jar planetiler.jar "--area=$location" "--mbtiles=/data/$location.mbtiles" --download --force
# fi
# Run tileserver-gl with the output file
echo "SERVING MBTILES"
# Make sure we're in the main folder
cd /
# Create the config to serve all mbtiles and styles
node createconfig.js #$location
# Start tileservergl
/usr/src/app/docker-entrypoint.sh