#!/bin/bash
SCRIPT_DIR=$(dirname $0)

if [ ! -z "${NODE_SERVICE_HOST_PATTERN}" ]; then 
  NEW_NODE_IP_LIST=$(${SCRIPT_DIR}/getNodeAddressList.sh ${NODE_SERVICE_HOST_PATTERN})
  rc=${?}; 
  if [[ ${rc} != 0 ]]; then
    echo "Call to getNodeAddressList.sh failed:"
    echo -e "\t${NEW_NODE_IP_LIST}"
    exit ${rc}; 
  fi

  NEW_NODE_COUNT=$(${SCRIPT_DIR}/getNodeCount.sh ${NEW_NODE_IP_LIST})
  rc=${?}; 
  if [[ ${rc} != 0 ]]; then
    echo "Call to getNodeCount.sh failed:"
    echo -e "\t${NEW_NODE_COUNT}"
    exit ${rc}; 
  fi    

  if [ ! -z "$NEW_NODE_IP_LIST" ]; then
    echo ===============================================================================
    echo "Configuring OpenShift environment ..."
    echo -------------------------------------------------------------------------------
    echo "Changing;"
    echo -e "\tNODE_IP_LIST: ${NODE_IP_LIST}"
    export NODE_IP_LIST=${NEW_NODE_IP_LIST}
#    NODE_IP_LIST = ${NEW_NODE_IP_LIST}
    echo -e "\tNODE_IP_LIST: ${NODE_IP_LIST}"
    echo -------------------------------------------------------------------------------
    echo "Changing;"
    echo -e "\tNODE_COUNT: ${NODE_COUNT}"
    export NODE_COUNT=${NEW_NODE_COUNT}
    echo -e "\tNODE_COUNT: ${NODE_COUNT}"
    echo ===============================================================================
    echo
  fi
fi


echo "Starting indy node ..."
echo

[[ ${NODE_NAME} =~ [^0-9]*([0-9]*) ]]
NODENUM=${BASH_REMATCH[1]}
IFS=', ' read -r -a node_ip <<< "${NODE_IP_LIST}"
echo "Setting Up Indy Node Number $NODENUM"
exec init_indy_node ${NODE_NAME} ${node_ip[$NODENUM-1]} ${NODE_PORT} ${node_ip[$NODENUM-1]} ${CLIENT_PORT}
exec generate_indy_pool_transactions --nodes 4 --clients 4 --nodeNum $NODENUM --ips ${NODE_IP_LIST}

#echo "Starting indy-node service ..."
#echo "/usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}"
#echo
#exec /usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}

# echo "Indy node started."
