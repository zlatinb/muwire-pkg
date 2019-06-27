#!/bin/bash
set -e

RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/win
I2P_JARS=../i2p.i2p/pkg-temp

rm -rf build *.exe
mkdir build

cp GPLv3.txt GPLv3-ud.txt
unix2dos GPLv3-ud.txt

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build
zip -d build/jbigi.jar *osx*
zip -d build/jbigi.jar *linux*
zip -d build/jbigi.jar *freebsd*

echo "copying JRE"
mkdir build/jre
cp -R $JVM_DIR/* build/jre


