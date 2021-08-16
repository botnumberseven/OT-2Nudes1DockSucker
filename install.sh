#!/bin/bash

#source /root/OT-Settings/config.sh

NODE_NAME=otnode
NODE_NUMBER=REPLACE
NODE_ID=$NODE_NAME$NODE_NUMBER

## Install the node and setup the environment

if [[$NODE_NUMBER == "replace "]]; then
  echo "Edit NODE_NUMBER to be the correct number of the node being installed."
  exit 1
fi

apt update

echo "apt install -y build-essential gcc python-dev ccze git jq"
apt install -y build-essential gcc python-dev ccze jq
if [[ $? -ne 0 ]]; then
  exit 1
fi

OS_VERSION=$(lsb_release -sr)
NODE_VERSION=$(curl -sL https://api.github.com/repos/origintrail/ot-node/releases/latest | jq -r .tag_name | tr -d 'v')

if [ $OS_VERSION != 18.04 ]; then
  echo "OT-2Nodes1Server requires Ubuntu 18.04. Destroy this VPS and remake using Ubuntu 18.04."
  exit 1
fi

echo "./install-otnode.sh"
./install-otnode.sh

echo "apt-mark hold arangodb3 nodejs"
apt-mark hold arangodb3 nodejs
if [[ $? -ne 0 ]]; then
  exit 1
fi

echo "mkdir -p /ot-node && mv /root/OT-2Nodes1Server/dockerless/ot-node/ /ot-node/$NODE_VERSION"
mkdir -p /ot-node && mv /root/OT-2Nodes1Server/ot-node/ /ot-node/$NODE_VERSION
if [[ $? -ne 0 ]]; then
  exit 1
fi

echo "ln -s /ot-node/$NODE_VERSION /ot-node/current && cd /ot-node/current"
ln -s /ot-node/$NODE_VERSION /ot-node/current && cd /ot-node/current
if [[ $? -ne 0 ]]; then
  exit 1
fi

echo NODE_ENV=mainnet >> .env
if [[ $? -ne 0 ]]; then
  exit 1
fi