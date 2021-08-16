#!/bin/bash

STATUS=$?
N1=$'\n'
BACKUPDIR=/root/mbackup

cd /ot-node/current

echo "Backing up OT Node data"
OUTPUT=$(node /ot-node/current/scripts/backup.js --config=/ot-node/current/.origintrail_noderc --configDir=/root/.origintrail_noderc/mainnet --backup_directory=$BACKUPDIR  2>&1 | tee /dev/tty )

if [ $? == 1 ]; then
  /root/OT-Settings/data/send.sh "OT backup command FAILED:${N1}$OUTPUT"
  exit 1
  echo "$OUTPUT"
fi
echo "Success!"

echo "Moving data out of dated folder into backup"
OUTPUT=$(mv -v $BACKUPDIR/202*/* $BACKUPDIR/ 2>&1 | tee /dev/tty)

if [ $? == 1 ]; then
  /root/OT-Settings/data/send.sh "Moving data command FAILED::${N1}$OUTPUT"
  echo "$OUTPUT"
  exit 1
fi
echo "Success!"

echo "Moving hidden data out of dated folder into backup"
OUTPUT=$(mv -v $BACKUPDIR/*/.origintrail_noderc $BACKUPDIR/ 2>&1 | tee /dev/tty)

if [ $? == 1 ]; then
  /root/OT-Settings/data/send.sh "Moving hidden data command FAILED:${N1}$OUTPUT"
  echo "$OUTPUT"
  exit 1
fi
echo "Success!"

echo "Deleting dated folder"
OUTPUT=$(rm -rf $BACKUPDIR/202* 2>&1 | tee /dev/tty)

if [ $? == 1 ]; then
  /root/OT-Settings/data/send.sh "Deleting data folder command FAILED:${N1}$OUTPUT"
  echo "$OUTPUT"
  exit 1
fi
echo "Success!"