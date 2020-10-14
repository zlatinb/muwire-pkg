#!/bin/bash
set -e

if [ -z $APPIMAGE_BINARY ]; then
    echo "set APPIMAGE_BINARY to point to the binary of the appimagetool"
    echo "optionally you can set APPIMAGE_OPTS for additional options"
    echo "(such as gpg-signing)"
    exit 1
fi

RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/linux
I2P_JARS=../i2p.i2p/pkg-temp
MUWIRE_DIR=../muwire/gui/griffon-app/resources

rm -rf build
mkdir -p build/pkg
mkdir -p build/MuWire.AppDir/usr/bin
mkdir -p build/MuWire.AppDir/jre

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build/pkg
zip -d build/pkg/jbigi.jar "*win*"
zip -d build/pkg/jbigi.jar "*osx*"
zip -d build/pkg/jbigi.jar "*freebsd*"

echo "copying JRE"
cp -R $JVM_DIR/* build/MuWire.AppDir/jre

echo "copying MW files"
cp build/pkg/jbigi.jar build/MuWire.AppDir
cp unnamed.jar build/MuWire.AppDir
cp MuWire.jar build/MuWire.AppDir
cp MuWire.desktop build/MuWire.AppDir
cp AppRun build/MuWire.AppDir
cp muwire-appimage-aarch64.sh build/MuWire.AppDir/usr/bin/muwire-appimage.sh
cp $MUWIRE_DIR/MuWire-48x48.png build/MuWire.AppDir
cp -R $RES_DIR/certificates build/MuWire.AppDir
cp $RES_DIR/countries.txt build/MuWire.AppDir
cp $RES_DIR/continents.txt build/MuWire.AppDir
cp $RES_DIR/GeoLite2-Country.mmdb.gz build/MuWire.AppDir
gunzip build/MuWire.AppDir/GeoLite2-Country.mmdb.gz
cp ../muwire/logging/1_logging.properties build/MuWire.AppDir

echo "Creating app image"

# this seems to be a bug in appimagetool, "aarch64" is not recognized?
ARCH=x86_64 $APPIMAGE_BINARY $APPIMAGE_OPTS build/MuWire.AppDir

echo "created Linux aarch64 App Image"
