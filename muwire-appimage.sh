#!/bin/bash

mkdir $HOME/.MuWire
cp -R ${HERE}/certificates $HOME/.MuWire
${HERE}/jre/bin/java -cp "${HERE}/jbigi.jar:${HERE}/MuWire.jar:${HERE}/unnamed.jar" -DembeddedRouter=true com.muwire.gui.Launcher

