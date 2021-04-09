#!/bin/bash
set -e

if [ -z "${JAVA_HOME}" ]; then
	echo "JAVA_HOME must point to JDK 14+"
	exit 1
fi

echo "cleaning"
./clean.sh

HERE=$PWD
I2P_JARS=$HERE/../../i2p.i2p/pkg-temp/lib
I2P_PKG=$HERE/../../i2p.i2p/pkg-temp
I2P_RES=$HERE/../../i2p.i2p/installer/resources
JVM_DIR=$HERE/../dist/win

mkdir build

MW_VERSION=$(cat ../VERSION)

echo "compiling custom launcher"
cp $HERE/../*.jar build
cd java
javac -d ../build -classpath ../build/MuWire.jar com/muwire/gui/WinLauncher.java
cd ..

echo "building launcher.jar"
cd build
jar -cf launcher.jar com 
rm -rf com 
cd ..

echo "copying jbigi"
cp "${I2P_JARS}"/jbigi.jar build

echo "preparing to invoke jpackage"
"${JAVA_HOME}"/bin/jpackage --name MuWire \
       --icon resources/MuWire.ico \
        --app-version $MW_VERSION \
        --description "MuWire: Easy Anonymous File-Sharing" \
        --java-options "-Xmx512M" \
		--java-options "--illegal-access=permit" \
        --input build \
        --main-jar MuWire.jar \
        --runtime-image ${JVM_DIR} \
        --main-class com.muwire.gui.WinLauncher \
        --type app-image

echo "copying certificates"
cp -R ${I2P_RES}/certificates MuWire

echo "copying geoip"
cp -R ${I2P_PKG}/geoip MuWire

echo "copying licenses"
cp -R ${I2P_PKG}/licenses MuWire
cp ${I2P_PKG}/LICENSE.txt MuWire/I2P-LICENSE.txt

echo "copying blocklist"
cp ${I2P_PKG}/blocklist.txt MuWire

echo "touching hosts.txt"
touch MuWire/hosts.txt
		
rm -rf build && mkdir build
echo "!define MUWIRE_VERSION $MW_VERSION" > build/version.nsi

mv MuWire build

cp nsis/installer.nsi build/

cp resources/GPLv3.txt build/
unix2dos build/GPLv3.txt

echo "You can now compile the installer.nsi in build directory"
