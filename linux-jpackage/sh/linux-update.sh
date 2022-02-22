#!/bin/bash
set -e

if [ -z $MW_PID ]; then
    echo "MW_PID not set"
    exit 1
fi

if [ -z ${MW_UPDATE_FILE} ]; then
    echo "MW_UPDATE_FILE not set"
    exit 1
fi

echo "Performing linux update, environment:"
echo "MW_PID $MW_PID"
echo "MW_UPDATE_FILE $MW_UPDATE_FILE"

if [ ! -f ${MW_UPDATE_FILE} ]; then
    echo "$MW_UPDATE FILE does not exist"
    exit 1
fi

echo "waiting for $MW_PID to terminate..."
while (0 -eq $(ps -q $MW_PID > /dev/null; echo $?) ]; do
    sleep 1
done

echo "executing $MW_UPDATE_FILE"

${MW_UPDATE_FILE}
