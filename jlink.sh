#!/bin/bash
set -e

if [ -z $JAVA_HOME ]; then
    echo "JAVA_HOME needs to point to Java 11"
    exit 1
fi

rm -f VERSION
rm -f *.tar
rm -f *.jar
rm -f *.class
rm -rf gui-*
rm -rf tmp
rm -rf module-info

PKG_TEMP=../muwire/gui/build/distributions
cp $PKG_TEMP/gui-shadow-*.tar .
VERSION=$(ls *.tar | sed "s/gui-shadow-\(.*\).tar/\1/")
echo "will build version $VERSION"

echo "!define MUWIRE_VERSION $VERSION" > version.nsi
echo $VERSION > VERSION

tar -xvf gui-*.tar > /dev/null

echo "moving unnamed packages out of the way"
mkdir tmp
mv gui-shadow-$VERSION/lib/gui-$VERSION-all.jar tmp/gui.jar
cd tmp
unzip gui.jar > /dev/null 
$JAVA_HOME/bin/jar -cf0 unnamed.jar *.class
mv unnamed.jar ../
rm *.class
rm gui.jar
$JAVA_HOME/bin/jar -cf0 MuWire.jar *
mv MuWire.jar ../
cd ..


echo "patching MuWirejar to create modules"
$JAVA_HOME/bin/javac -nowarn --module-path . --patch-module MuWire=MuWire.jar module-info.java
echo "patched"
$JAVA_HOME/bin/jar uf MuWire.jar -C . module-info.class

echo "JLinking..."
rm -rf dist
if [ ! -z $JAVA_HOME_LINUX ]; then 
    echo "Linux"
    $JAVA_HOME/bin/jlink --module-path=$JAVA_HOME_LINUX/jmods:. --add-modules $(cat jlink.modules) --output dist/linux --strip-debug --compress 0 --no-header-files --no-man-pages
fi
if [ ! -z $JAVA_HOME_MAC ]; then
    echo "Mac"
    $JAVA_HOME/bin/jlink --module-path=$JAVA_HOME_MAC/jmods:. --add-modules $(cat jlink.modules) --output dist/mac --strip-debug --compress 0 --no-header-files --no-man-pages
fi
if [ ! -z $JAVA_HOME_WIN ]; then
    echo "Win"
    $JAVA_HOME/bin/jlink --module-path=$JAVA_HOME_WIN/jmods:. --add-modules $(cat jlink.modules) --output dist/win --strip-debug --compress 0 --no-header-files --no-man-pages
fi

echo "Done."

