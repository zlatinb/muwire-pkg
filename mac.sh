#!/bin/bash
set -e

VERSION=$(cat VERSION)
RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/mac
I2P_JARS=../i2p.i2p/pkg-temp
MW_DIR=../muwire/logging

rm -rf build
mkdir -p build/pkg
mkdir -p build/MuWire.app/Contents/MacOS
mkdir -p build/MuWire.app/Contents/Resources/jre

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build/pkg
zip -d build/pkg/jbigi.jar "*win*"
zip -d build/pkg/jbigi.jar "*linux*"
zip -d build/pkg/jbigi.jar "*freebsd*"

echo "preparing Info.plist"
cat Info.plist.template | sed "s/__VERSION__/${VERSION}/g" > Info.plist

echo "copying jre"
cp Info.plist build/MuWire.app/Contents
cp muwire-mac.sh build/MuWire.app/Contents/MacOS
cp -R $JVM_DIR/* build/MuWire.app/Contents/Resources/jre

echo "copying MW files"
cp build/pkg/jbigi.jar build/MuWire.app/Contents/Resources
cp MuWire.jar build/MuWire.app/Contents/Resources
cp unnamed.jar build/MuWire.app/Contents/Resources
cp -R $RES_DIR/certificates build/MuWire.app/Contents/Resources
cp $RES_DIR/countries.txt build/MuWire.app/Contents/Resources
cp $RES_DIR/continents.txt build/MuWire.app/Contents/Resources
cp $RES_DIR/GeoLite2-Country.mmdb.gz build/MuWire.app/Contents/Resources
gunzip build/MuWire.app/Contents/Resources/GeoLite2-Country.mmdb.gz
cp -R $MW_DIR/0_logging.properties build/MuWire.app/Contents/Resources
cp MuWire.icns build/MuWire.app/Contents/Resources
cp ../muwire/gui/griffon-app/resources/MuWire-128x128.png build/MuWire.app/Contents/Resources

echo "zipping.."

cd build
zip -r MuWire-mac-$VERSION.zip MuWire.app
cp MuWire-mac-$VERSION.zip ../
cd ..
echo "done"
