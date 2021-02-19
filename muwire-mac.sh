#!/bin/bash

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/.." >/dev/null
APP_HOME="`pwd -P`"
RESDIR=$APP_HOME/Resources
cd "$SAVED" >/dev/null

CONFDIR="$HOME/Library/Application Support/MuWire"
mkdir -p "${CONFDIR}"
cp -R $RESDIR/certificates "$CONFDIR"
mkdir -p "${CONFDIR}/geoip"
cp $RESDIR/GeoLite2-Country.mmdb "${CONFDIR}/geoip"

#need to launch from outside the appbundle because of jbigi
cd "${CONFDIR}"
"${RESDIR}"/jre/bin/java -Xmx512m -Xdock:name=MuWire -Xdock:icon="${RESDIR}"/MuWire-128x128.png -cp "$RESDIR/jbigi.jar:$RESDIR/MuWire.jar:$RESDIR/unnamed.jar" -DembeddedRouter=true -DupdateType=mac -Djava.util.logging.config.file=0_logging.properties com.muwire.gui.Launcher

