#!/bin/bash

STATUS=$?
N1=$'\n'
BACKUPDIR=/root/mbackup
NODENAME=*CHANGE*

cp $BACKUPDIR/houston.txt /ot-node/data/$NODENAME/
cp $BACKUPDIR/identity.json /ot-node/data/$NODENAME/
cp $BACKUPDIR/kademlia* /ot-node/data/$NODENAME/
cp $BACKUPDIR/system.db /ot-node/data/$NODENAME/
cp $BACKUPDIR/xdai_erc725_identity.json /ot-node/data/$NODENAME/
cp -r $BACKUPDIR/migrations /ot-node/data/$NODENAME/

arangorestore --server.database $NODENAME --server.username root --server.password "root" --input-directory /root/$BACKUPDIR/arangodb/ --overwrite true --create-database true