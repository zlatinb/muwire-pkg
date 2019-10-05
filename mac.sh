#!/bin/bash
set -e

RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/mac
I2P_JARS=../i2p.i2p/pkg-temp

rm -rf build
mkdir -p build/pkg
mkdir -p build/MuWire.app/Contents/MacOS/jre

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build/pkg
zip -d build/pkg/jbigi.jar *win*
zip -d build/pkg/jbigi.jar *linux*
zip -d build/pkg/jbigi.jar *freebsd*

echo "copying jre"
cp Info.plist build/MuWire.app/Contents
cp muwire.sh build/MuWire.app/Contents/MacOS
cp -R $JVM_DIR/* build/MuWire.app/Contents/MacOS/jre

echo "copying MW files"
cp build/pkg/jbigi.jar build/MuWire.app/Contents/MacOS
cp MuWire.jar build/MuWire.app/Contents/MacOS
cp unnamed.jar build/MuWire.app/Contents/MacOS
cp -R $RES_DIR/certificates build/MuWire.app/Contents/MacOS

echo "zipping.."

cd build
zip -r MuWire.zip MuWire.app
cp MuWire.zip ../
cd ..
echo "done"