#!/bin/bash
set -e

if [ -z $APPIMAGE_BINARY ]; then
    echo "set APPIMAGE_BINARY to point to the binary of the appimagetool"
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
zip -d build/pkg/jbigi.jar *win*
zip -d build/pkg/jbigi.jar *osx*
zip -d build/pkg/jbigi.jar *freebsd*

echo "copying JRE"
cp -R $JVM_DIR/* build/MuWire.AppDir/jre

echo "copying MW files"
cp build/pkg/jbigi.jar build/MuWire.AppDir
cp unnamed.jar build/MuWire.AppDir
cp MuWire.jar build/MuWire.AppDir
cp MuWire.desktop build/MuWire.AppDir
cp AppRun build/MuWire.AppDir
cp muwire-appimage.sh build/MuWire.AppDir/usr/bin
cp $MUWIRE_DIR/MuWire-48x48.png build/MuWire.AppDir

echo "Creating app image"

ARCH=x86_64 $APPIMAGE_BINARY build/MuWire.AppDir

echo "created Linux App Image"
