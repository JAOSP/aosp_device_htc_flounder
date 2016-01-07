#!/bin/sh

VENDOR=htc
DEVICE=flounder

echo "Please wait..."
wget -nc -q https://dl.google.com/dl/android/aosp/volantis-mmb29s-factory-80118d3a.tgz
tar zxf volantis-mmb29s-factory-80118d3a.tgz
rm volantis-mmb29s-factory-80118d3a.tgz
cd volantis-mmb29s
unzip image-volantis-mmb29s.zip
rm image-volantis-mmb29s.zip
cd ../
./simg2img volantis-mmb29s/vendor.img vendor.ext4.img
mkdir vendor
sudo mount -o loop -t ext4 vendor.ext4.img vendor
./simg2img volantis-mmb29s/system.img system.ext4.img
mkdir system
sudo mount -o loop -t ext4 system.ext4.img system

BASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $BASE/*

for FILE in `cat proprietary-vendor-blobs.txt | grep -v ^# | grep -v ^$ | sed -e 's#^/system/##g'| sed -e "s#^-/system/##g"`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    cp ./$FILE $BASE/$FILE

done

for FILE in `cat proprietary-system-blobs.txt | grep -v ^# | grep -v ^$ | sed -e 's#^/system/##g'| sed -e "s#^-/system/##g"`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    cp ./$FILE $BASE/$FILE

done

./setup-makefiles.sh

sudo umount vendor
rm -rf vendor
sudo umount system
rm -rf system
rm -rf volantis-mmb29s
rm vendor.ext4.img
rm system.ext4.img
