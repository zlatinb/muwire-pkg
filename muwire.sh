#!/bin/bash

if [ $(uname -s) = Darwin ]; then
    cd "$(dirname "$0")"
    jre/bin/java -cp "jbigi.jar:MuWire.jar:unnamed.jar" -DembeddedRouter=true com.muwire.gui.Launcher
else
    basedir=$(dirname $(dirname $(readlink -fm $0)))
    "$basedir"jre/bin/java -cp "$basedir/jbigi.jar:$basedir/MuWire.jar:$basedir/unnamed.jar" -DembeddedRouter=true com.muwire.gui.Launcher
fi

