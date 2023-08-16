#!/bin/bash

URL=$1

while true;
do

echo "Running Spider..."

wget -r --spider --delete-after --force-html --reject js,css,jpg,jpeg,png,gif $1 2>&1 | grep "camsoda.com/" | awk '{FS=" "}{if(substr($0, 1, 2)=="--") print $3}' >> /tmp/camsoda.urls.txt

echo "Filtering output..."

cat /tmp/camsoda.urls.txt | sort | uniq > /tmp/camsoda.urls.tmp

mv /tmp/camsoda.urls.tmp /tmp/camsoda.urls.txt

wc -l /tmp/camsoda.urls.txt

echo "Done!"

done


