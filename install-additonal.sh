#!/bin/bash

NODE_NAME=otnode
NODE_NUMBER=CHANGE
NODE_ID=$NODE_NAME$NODE_NUMBER

if [[ NODE_NUMBER -eq 10 ]]; then
  ufw allow 3010 && ufw allow 5310 && ufw allow 8910 && ufw enable
else
  ufw allow 300$NODE_NUMBER && ufw allow 530$NODE_NUMBER && ufw allow 890$NODE_NUMBER && yes | ufw enable
fi

cp /root/OT-2Nudes1DockSucker/otnode.service /lib/systemd/system/$NODE_ID.service

sed -i "s|otnodeX|$NODE_ID|g" /lib/systemd/system/$NODE_ID.service

BACKUPDIR=/root/backup

arangorestore --server.database $NODE_ID --server.username root --server.password "root" --input-directory $BACKUPDIR/arangodb/ --overwrite true --create-database true

if [[ $? -eq 1 ]]; then
  echo "Restore has an error"
  exit 1
fi

rm -rf $BACKUPDIR/arangodb

DEST_DIR=/ot-node/data/$NODE_ID
mkdir -p $DEST_DIR

cp $BACKUPDIR/.origintrail_noderc $DEST_DIR
cp $BACKUPDIR/houston.txt $DEST_DIR
cp $BACKUPDIR/identity.json $DEST_DIR
cp $BACKUPDIR/kademlia* $DEST_DIR
cp $BACKUPDIR/system.db $DEST_DIR
cp $BACKUPDIR/xdai_erc725_identity.json $DEST_DIR
cp -r $BACKUPDIR/migrations $DEST_DIR

cp /root/OT-2Nudes1DockSucker/start-script $DEST_DIR/$NODE_ID
sed -i "s|otnodeX|$NODE_ID|g" $DEST_DIR/$NODE_ID

systemctl enable $NODE_ID
#systemctl start $NODE_ID
#
