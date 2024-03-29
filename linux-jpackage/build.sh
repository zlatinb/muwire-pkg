#!/bin/bash
set -e

if [ -z "${JAVA_HOME}" ]; then
    echo "JAVA_HOME must point to JDK 14+"
    exit 1
fi

if [ -z $APPIMAGE_BINARY ]; then
    echo "set APPIMAGE_BINARY to point to the binary of the appimagetool"
    echo "optionally you can set APPIMAGE_OPTS for additional options"
    echo "(such as gpg-signing)"
    exit 1
fi

echo "cleaning"
./clean.sh

HERE=$PWD
I2P_JARS=$HERE/../../i2p.i2p/pkg-temp/lib
I2P_PKG=$HERE/../../i2p.i2p/pkg-temp
I2P_RES=$HERE/../../i2p.i2p/installer/resources
MUWIRE_DIR=$HERE/../../muwire/gui/griffon-app/resources
JVM_DIR=$HERE/../dist/linux
ARCH=$(uname -m)
MW_UPDATE_TYPE="appimage"
if [ "aarch64" = $ARCH ]; then
    MW_UPDATE_TYPE="appimage-aarch64"
fi

mkdir build

MW_VERSION=$(cat ../VERSION)

echo "compiling custom launcher"
cp $HERE/../*.jar build
cd java
$JAVA_HOME/bin/javac -d ../build -classpath ../build/MuWire.jar com/muwire/gui/LinuxLauncher.java com/muwire/core/update/LinuxUpdater.java
cd ..

echo "copying linux-update.sh"
cp sh/linux-update.sh build

echo "building launcher.jar"
cd build
$JAVA_HOME/bin/jar -cf launcher.jar com linux-update.sh
rm -rf com linux-update.sh
cd ..



echo "copying jbigi"
cp "${I2P_JARS}"/jbigi.jar build

echo "preparing to invoke jpackage for version $MW_VERSION update type $MW_UPDATE_TYPE"
"${JAVA_HOME}"/bin/jpackage --name MuWire \
        --app-version $MW_VERSION \
        --description "MuWire: Easy Anonymous File-Sharing" \
        --java-options "-Xms512M" \
        --java-options "-Xmx4G" \
        --java-options "-XX:+UseParallelGC" \
        --java-options "-DupdateType=$MW_UPDATE_TYPE" \
        --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
        --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
        --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
        --java-options "--add-opens java.base/java.util=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/java.awt=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/javax.swing=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/javax.swing.tree=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/javax.swing.plaf.basic=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/sun.swing=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/javax.swing.text.html=ALL-UNNAMED" \
        --java-options "--add-opens java.desktop/com.sun.java.swing.plaf.gtk=ALL-UNNAMED" \
        --input build \
        --main-jar MuWire.jar \
        --runtime-image ${JVM_DIR} \
        --main-class com.muwire.gui.LinuxLauncher \
        --type app-image

echo "copying certificates"
cp -R ${I2P_RES}/certificates MuWire/lib

echo "copying geoip"
cp -R ${I2P_PKG}/geoip MuWire/lib

echo "copying licenses"
cp -R ${I2P_PKG}/licenses MuWire/lib
cp ${I2P_PKG}/LICENSE.txt MuWire/lib/I2P-LICENSE.txt

echo "copying blocklist"
cp ${I2P_PKG}/blocklist.txt MuWire/lib

echo "touching hosts.txt"
touch MuWire/lib/hosts.txt

echo "preparing AppDir"
mkdir -p build/MuWire.AppDir
mv MuWire build/MuWire.AppDir
cp resources/AppRun build/MuWire.AppDir
cp resources/MuWire.desktop build/MuWire.AppDir
cp $MUWIRE_DIR/MuWire-48x48.png build/MuWire.AppDir

echo "creating app image"
# this is a bug in appimage - architecture needs to be x86_64 even on aarch64
ARCH=x86_64 $APPIMAGE_BINARY $APPIMAGE_OPTS build/MuWire.AppDir
