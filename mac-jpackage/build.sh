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
javac -d ../build -classpath ../build/MuWire.jar:../build/unnamed.jar com/muwire/gui/MacLauncher.java com/muwire/core/update/MacUpdater.java
cd ..

echo "compiling native lib"
cc -v -Wl,-lobjc -mmacosx-version-min=10.9 -I"$JAVA_HOME/include" -I"$JAVA_HOME/include/darwin" -Ic -o build/libMacLauncher.jnilib -shared c/com_muwire_gui_MacLauncher.c

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

echo "building launcher.jar"
cp sh/mac-update.sh build
cd build
jar -cf launcher.jar com mac-update.sh
rm -rf com 
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
    --java-options "-Xms512m" \
    --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
    --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
    --java-options "--add-opens java.desktop/java.awt=ALL-UNNAMED" \
    --java-options "--add-opens java.desktop/javax.swing=ALL-UNNAMED" \
    --java-options "--add-opens java.desktop/javax.swing.plaf.basic=ALL-UNNAMED" \
    --java-options "--add-opens java.desktop/sun.swing=ALL-UNNAMED" \
    --java-options "--add-opens java.desktop/javax.swing.text.html=ALL-UNNAMED" \
    --java-options "--add-exports java.desktop/com.apple.laf=ALL-UNNAMED" \
    --mac-package-identifier MuWire \
    --resource-dir res  \
    --input build \
    --main-jar launcher.jar \
    --main-class com.muwire.gui.MacLauncher

echo "Copying certificates"
cp -R $I2P_RES/certificates MuWire.app/Contents/Resources

echo "Copying geoip"
cp -R $I2P_PKG/geoip MuWire.app/Contents/Resources

echo "Copying native lib"
cp $HERE/build/libMacLauncher.jnilib MuWire.app/Contents/Resources

echo "copying licenses"
cp -R ${I2P_PKG}/licenses MuWire.app/Contents/Resources
cp ${I2P_PKG}/LICENSE.txt MuWire.app/Contents/Resources/I2P-LICENSE.txt

echo "copying blocklist"
cp ${I2P_PKG}/blocklist.txt MuWire.app/Contents/Resources

echo "touching hosts.txt"
touch MuWire.app/Contents/Resources/hosts.txt

echo "signing runtime libraries"
find MuWire.app -name *.dylib -exec codesign --force -s $MW_SIGNER -v '{}' \;
find MuWire.app -name *.jnilib -exec codesign --force -s $MW_SIGNER -v '{}' \;

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

