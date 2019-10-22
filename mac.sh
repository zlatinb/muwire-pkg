#!/bin/bash
set -e

RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/mac
I2P_JARS=../i2p.i2p/pkg-temp
MW_DIR=../muwire/logging

rm -rf build
mkdir -p build/pkg
mkdir -p build/MuWire.app/Contents/MacOS/jre
mkdir -p build/MuWire.app/Contents/Resources

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build/pkg
zip -d build/pkg/jbigi.jar "*win*"
zip -d build/pkg/jbigi.jar "*linux*"
zip -d build/pkg/jbigi.jar "*freebsd*"

echo "copying jre"
cp Info.plist build/MuWire.app/Contents
cp muwire-mac.sh build/MuWire.app/Contents/MacOS
cp -R $JVM_DIR/* build/MuWire.app/Contents/MacOS/jre

echo "copying MW files"
cp build/pkg/jbigi.jar build/MuWire.app/Contents/MacOS
cp MuWire.jar build/MuWire.app/Contents/MacOS
cp unnamed.jar build/MuWire.app/Contents/MacOS
cp -R $RES_DIR/certificates build/MuWire.app/Contents/MacOS
cp -R $MW_DIR/1_logging.properties build/MuWire.app/Contents/MacOS
cp MuWire.icns build/MuWire.app/Contents/Resources
cp ../muwire/gui/griffon-app/resources/MuWire-128x128.png build/MuWire.app/Contents/Resources

echo "zipping.."

cd build
zip -r MuWire.zip MuWire.app
cp MuWire.zip ../
cd ..
echo "done"
