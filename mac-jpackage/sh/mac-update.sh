#!/bin/bash
set -e

if [ -z $MW_PID ]; then
    echo "MW_PID not set"
    exit 1
fi

if [ -z "${MW_UPDATE_FILE}" ]; then
    echo "MW_UPDATE_FILE does not exit"
    exit 1
fi

if [ -z "${MW_BUNDLE_LOCATION}" ]; then
    echo "MW_BUNDLE_LOCATION not set"
    exit 1
fi

echo "performing mac update, environment:"
echo "MW_PID $MW_PID"
echo "MW_UPDATE_FILE ${MW_UPDATE_FILE}"
echo "MW_BUNDLE_LOCATION ${MW_BUNDLE_LOCATION}"

echo "waiting for $MW_PID to terminate..."
while [ 0 -eq $(ps -o pid $MW_PID > /dev/null ; echo $?) ]; do
    sleep 1
done

echo "cleaning up"
rm -rfv mount_point MuWire.cdr

echo "converting to CDR format"
hdiutil convert -quiet -format UDTO -o MuWire "${MW_UPDATE_FILE}"

echo "mounting"
hdiutil attach -quiet -nobrowse -noverify -noautoopen -mountpoint mount_point MuWire.cdr

echo "removing old MuWire.app"
rm -rf "${MW_BUNDLE_LOCATION}"/MuWire.app

echo "copying new MuWire.app"
cp -R mount_point/MuWire.app "${MW_BUNDLE_LOCATION}"

echo "unmounting old and cleaning up"
hdiutil detach mount_point
rm -f MuWire.cdr "${MW_UPDATE_FILE}"

echo "launching MuWire"
open "${MW_BUNDLE_LOCATION}"/MuWire.app
