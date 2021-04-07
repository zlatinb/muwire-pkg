#!/bin/bash
set -e

JAVA=$(java --version 2>&1 | tr -d 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n' | cut -d ' ' -f 2 | cut -d '.' -f 1 | tr -d '\n\t ')

if [ -z "$JAVA" ]; then
    echo "Failed to parse Java version, java is:"
    java -version
    exit 1
fi

if [ "$JAVA" -lt "16" ]; then
    echo "Java 16+ must be used to compile with jpackage on Mac, java is $JAVA"
    exit 1
fi

if [ -z "${MW_SIGNER}" ]; then
    echo "MW_SIGNER variable not set, can't sign.  Aborting..."
    exit 1
fi

if [ -z ${MW_BUILD_NUMBER} ]; then
    echo "please set the MW_BUILD_NUMBER variable to some integer >= 1"
    exit 1
fi

echo "cleaning"
./clean.sh

HERE=$PWD
I2P_JARS=$HERE/../../i2p.i2p/pkg-temp/lib
I2P_PKG=$HERE/../../i2p.i2p/pkg-temp
I2P_RES=$HERE/../../i2p.i2p/installer/resources

mkdir build

echo "compiling custom launcher"
cp $HERE/../*.jar build
cd java
javac -d ../build -classpath ../build/MuWire.jar:../build/unnamed.jar com/muwire/gui/MacLauncher.java
cd ..


echo "signing jbigi libs"
mkdir jbigi
cp $I2P_JARS/jbigi.jar jbigi
cd jbigi
unzip jbigi.jar
for lib in *.jnilib; do
    codesign --force -s $MW_SIGNER -v $lib
    jar uf jbigi.jar $lib
done
cp jbigi.jar ../build
cd ..


echo "preparing resources.csv"
cd $I2P_RES
find certificates -name *.crt -exec echo '{},{},true' >> $HERE/build/resources.csv \;
cd $HERE
echo "geoip/GeoLite2-Country.mmdb,geoip/GeoLite2-Country.mmdb,true" >> build/resources.csv
# TODO: decide on blocklist.txt

echo "copying certificates"
cp -R $I2P_RES/certificates build/

echo "copying geoip"
mkdir build/geoip
cp $I2P_RES/GeoLite2-Country.mmdb.gz build/geoip
gunzip build/geoip/GeoLite2-Country.mmdb.gz

echo "building launcher.jar"
cd build
jar -cf launcher.jar com certificates geoip resources.csv
rm -rf com certificates geoip resources.csv
cd ..

MW_VERSION=$(cat ../VERSION)
mkdir res

echo "Preparing Info.plist"
cp resources/Info.plist.template res/Info.plist
sed -i.bak "s/MW_VERSION/$MW_VERSION/g" res/Info.plist
sed -i.bak "s/MW_BUILD_NUMBER/$MW_BUILD_NUMBER/g" res/Info.plist
rm res/Info.plist.bak

echo "Preparing dmg script"
cp resources/MuWire-dmg-setup.scpt.template res/MuWire-dmg-setup.scpt
sed -i.bak "s@__HERE__@${HERE}@g" res/MuWire-dmg-setup.scpt
rm res/*.bak

echo "Copying icons"
cp resources/MuWire.icns res
cp resources/MuWire.icns res/MuWire-volume.icns
cp resources/MuWire-background.tiff res

echo "Preparing to invoke JPackage for MuWire version $MW_VERSION build $MW_BUILD_NUMBER"
jpackage --runtime-image ../dist/mac \
    --type app-image \
    --name MuWire \
    --java-options "-Xmx512m" \
    --java-options "--illegal-access=permit" \
    --mac-package-identifier MuWire \
    --resource-dir res  \
    --input build \
    --main-jar launcher.jar \
    --main-class com.muwire.gui.MacLauncher

echo "signing runtime libraries"
find MuWire.app -name *.dylib -exec codesign --force -s $MW_SIGNER -v '{}' \;

echo "signing the bundle"
codesign --force -d --deep -f \
    --options=runtime \
    --entitlements resources/entitlements.xml \
    -s $MW_SIGNER \
    --verbose=4 \
    MuWire.app

echo "invoking jpackage again to build a dmg"
jpackage --name MuWire --app-image MuWire.app --app-version $MW_VERSION \
        --verbose \
        --temp tmp \
        --license-file ../GPLv3.txt \
        --resource-dir res

