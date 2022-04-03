#!/bin/bash
SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/initialize.sh


echo ${NODE_NAME} 

echo ${NODE_PORT} 

echo ${CLIENT_PORT}

echo "${NODE_IP_LIST}"




#[[ ${NODE_NAME} =~ [^0-9]*([0-9]*) ]]
#NODENUM=${BASH_REMATCH[1]}
#echo "Setting Up Indy Node Number $NODENUM"
#exec su - indy -c "init_indy_node ${NODE_NAME} ${NODE_PORT} ${CLIENT_PORT}"  # set up /etc/indy/indy.env 
#exec su - indy -c "generate_indy_pool_transactions --nodes 4 --clients 4 --nodeNum $NODENUM --ips ${NODE_IP_LIST}"
#exec systemctl start indy-node
#exec systemctl enable indy-node
#exec systemctl status indy-node.service

