#!/bin/bash
set -e

RES_DIR=../i2p.i2p/installer/resources
JVM_DIR=dist/win
I2P_JARS=../i2p.i2p/pkg-temp
MW_DIR=../muwire

rm -rf build *.exe
mkdir -p build/pkg

cp GPLv3.txt build/GPLv3-ud.txt
unix2dos build/GPLv3-ud.txt

echo "preparing jbigi"
cp $I2P_JARS/lib/jbigi.jar build/pkg
zip -d build/pkg/jbigi.jar "*osx*"
zip -d build/pkg/jbigi.jar "*linux*"
zip -d build/pkg/jbigi.jar "*freebsd*"

echo "copying files"
cp unnamed.jar build/pkg
cp MuWire.jar build/pkg
cp muwire.bat build/pkg
cp -R $RES_DIR/certificates build/pkg
cp $RES_DIR/GeoLite2-Country.mmdb.gz build/pkg
gunzip build/pkg/GeoLite2-Country.mmdb.gz
cp $MW_DIR/logging/1_logging.properties build/pkg

echo "copying JRE"
mkdir build/jre
cp -R $JVM_DIR/* build/jre

cp MuWire.ico build
cp installer.nsi build
cp version.nsi build
cd build && makensis installer.nsi && cp MuWire-*.exe ../ && \
    cd .. && echo "built windows installer"
