#!/bin/bash

NODE_NAME=otnode
NODE_NUMBER=CHANGE
NODE_ID=$NODE_NAME$NODE_NUMBER
DEST_DIR=/ot-node/data/$NODE_ID

if [[ NODE_NUMBER -eq 10 ]]; then
  ufw allow 3010 && ufw allow 5310 && ufw allow 8910 && ufw enable
else
  ufw allow 300$NODE_NUMBER && ufw allow 530$NODE_NUMBER && ufw allow 890$NODE_NUMBER && yes | ufw enable
fi

mkdir -p $DEST_DIR

cp /root/origintrail_noderc $DEST_DIR
cp /root/OT-2Nudes1DockSucker/otnode.service /lib/systemd/system/$NODE_ID.service

sed -i "s|otnodeX|$NODE_ID|g" /lib/systemd/system/$NODE_ID.service

cp /root/OT-2Nudes1DockSucker/start-script $DEST_DIR/$NODE_ID
sed -i "s|otnodeX|$NODE_ID|g" $DEST_DIR/$NODE_ID

cd /ot-node/current/
npm run setup
mv /root/.origintrail_noderc/mainnet/system.db $DEST_DIR

systemctl enable $NODE_ID
#systemctl start $NODE_ID
#
