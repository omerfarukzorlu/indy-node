#!/bin/bash
SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/initialize.sh

echo "Starting indy node ..."
echo

echo ${NODE_NAME} 
echo ${NODE_PORT} 
echo ${CLIENT_PORT}
echo "${NODE_IP_LIST}"

# echo "Starting indy-node-control service ..."
# echo "/usr/bin/env python3 -O /usr/local/bin/start_node_control_tool.py ${TEST_MODE} --hold-ext ${HOLD_EXT}"
# echo
# exec /usr/bin/env python3 -O /usr/local/bin/start_node_control_tool.py ${TEST_MODE} --hold-ext ${HOLD_EXT} &
# sleep 10
[[ ${NODE_NAME} =~ [^0-9]*([0-9]*) ]]
NODENUM=${BASH_REMATCH[1]}
echo "Setting Up Indy Node Number $NODENUM"

exec indy -c "init_indy_node ${NODE_NAME} ${NODE_PORT} ${CLIENT_PORT}"  # set up /etc/indy/indy.env
exec indy -c "generate_indy_pool_transactions --nodes 4 --clients 4 --nodeNum $NODENUM --ips ${NODE_IP_LIST}"

#echo "Starting indy-node service ..."
#echo "/usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}"
#echo
#exec /usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}

# echo "Indy node started."
