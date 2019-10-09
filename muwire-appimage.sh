#!/bin/bash

mkdir $HOME/.MuWire
cp -R ${HERE}/certificates $HOME/.MuWire
${HERE}/jre/bin/java -cp "${HERE}/jbigi.jar:${HERE}/MuWire.jar:${HERE}/unnamed.jar" -DembeddedRouter=true -Djava.util.logging.config.file=${HERE}/1_logging.properties com.muwire.gui.Launcher

