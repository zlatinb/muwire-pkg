#!/bin/bash

cd "$(dirname "$0")"
mkdir -p "$HOME/Library/Application Support/MuWire"
cp -R certificates "$HOME/Library/Application Support/MuWire"
jre/bin/java -cp "jbigi.jar:MuWire.jar:unnamed.jar" -DembeddedRouter=true com.muwire.gui.Launcher

