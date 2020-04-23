#!/bin/bash
set -e


RES_DIR=../i2p.i2p/installer/resources
LIB_DIR=lib-tmp
JVM_DIR=dist/win
I2P_JARS=../i2p.i2p/pkg-temp
DEST_DIR=MuWire
MW_DIR=../muwire
VERSION=$(cat VERSION)

rm -rf $LIB_DIR $DEST_DIR build

echo "preparing lib dir for jpackage"

mkdir $LIB_DIR
cp unnamed.jar $LIB_DIR
cp MuWire.jar $LIB_DIR
cp "${MW_DIR}"/logging/1_logging.properties $LIB_DIR

echo "preparing jbigi"
cp "${I2P_JARS}"/lib/jbigi.jar $LIB_DIR
# TODO - add instructions how to install zip or find another way
#zip -d $LIB_DIR/jbigi.jar "*osx*"
#zip -d $LIB_DIR/jbigi.jar "*linux*"
#zip -d $LIB_DIR/jbigi.jar "*freebsd*"

echo "executing jpackage"

"${JAVA_HOME}"/bin/jpackage --name MuWire \
       --icon MuWire.ico \
        --app-version $VERSION \
        --description "MuWire: Easy Anonymous File-Sharing" \
        --java-options "-Djava.library.path=\"\$ROOTDIR;\$ROOTDIR\\app\"" \
        --java-options "-DembeddedRouter=true" \
        --java-options "-DupdateType=exe" \
        --java-options "-Djava.util.logging.config.file=\$ROOTDIR\\app\\1_logging.properties" \
        --java-options "-Xmx512M" \
        --input $LIB_DIR \
        --main-jar MuWire.jar \
        --runtime-image $JVM_DIR \
        --main-class com.muwire.gui.Launcher \
        --type app-image

rm -rf $LIB_DIR

echo "copying files"
mkdir -p build/pkg

cp MuWire.ico build
cp GPLv3.txt build/GPLv3-ud.txt
unix2dos build/GPLv3-ud.txt
cp version.nsi build

cp -R $RES_DIR/certificates build/pkg
cp $RES_DIR/countries.txt build/pkg
cp $RES_DIR/continents.txt build/pkg
cp $RES_DIR/GeoLite2-Country.mmdb.gz build/pkg
gunzip build/pkg/GeoLite2-Country.mmdb.gz

cp -R $DEST_DIR/* build/pkg

cp installer-jpackage.nsi build/

echo "done"
