#!/bin/bash
SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/initialize.sh

echo "Starting indy node ..."
echo

# echo "Starting indy-node-control service ..."
# echo "/usr/bin/env python3 -O /usr/local/bin/start_node_control_tool.py ${TEST_MODE} --hold-ext ${HOLD_EXT}"
# echo
# exec /usr/bin/env python3 -O /usr/local/bin/start_node_control_tool.py ${TEST_MODE} --hold-ext ${HOLD_EXT} &
# sleep 10



display_usage() {
	echo -e "Usage:\t$0 <NODENAME> <NODEIP> <NODEPORT> <CLIENTIP> <CLIENTPORT> <TIMEZONE>"
	echo -e "EXAMPLE: $0 Node1 0.0.0.0 9701 0.0.0.0 9702 /usr/share/zoneinfo/America/Denver"
}

echo ${NODE_NAME} 

echo ${NODE_PORT} 

echo ${CLIENT_PORT}

echo "${NODE_IP_LIST}"

# if less than one argument is supplied, display usage
#if [  $# -ne 4 ]
#then
#    display_usage
#    exit 1
#fi


HOSTNAME=${NODE_NAME} 
NODEIP=${NODE_PORT}
NODEPORT=${CLIENT_PORT}
CLIENTIP=$4
CLIENTPORT=$5
TIMEZONE=$6
IPLIST=$7


#--------------------------------------------------------
echo 'Setting Up Networking'
echo /etc/hosts
#perl -p -i -e 's/(PasswordAuthentication\s+)no/$1yes/' /etc/ssh/sshd_config
#service sshd restart

#--------------------------------------------------------
echo 'Setting up timezone'
cp $TIMEZONE /etc/localtime

#--------------------------------------------------------
echo "Installing Required Packages"
su apt-get update
su apt-get install -y software-properties-common python-software-properties
su apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
su add-apt-repository "deb https://repo.sovrin.org/deb xenial stable"
su apt-get update
#DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get install -y unzip make screen indy-node tmux vim wget

awk '{if (index($1, "NETWORK_NAME") != 0) {print("NETWORK_NAME =\"sandbox\"")} else print($0)}' /etc/indy/indy_config.py> /tmp/indy_config.py
mv /tmp/indy_config.py /etc/indy/indy_config.py

#--------------------------------------------------------
[[ $HOSTNAME =~ [^0-9]*([0-9]*) ]]
NODENUM=${BASH_REMATCH[1]}
echo "Setting Up Indy Node Number $NODENUM"
su - indy -c "init_indy_node $HOSTNAME $NODEIP $NODEPORT $CLIENTIP $CLIENTPORT"  # set up /etc/indy/indy.env	
su - indy -c "generate_indy_pool_transactions --nodes 4 --clients 4 --nodeNum $NODENUM --ips $IPLIST"
systemctl start indy-node
systemctl enable indy-node
systemctl status indy-node.service

#--------------------------------------------------------
echo 'Fixing Bugs'
if grep -Fxq '[Install]' /etc/systemd/system/indy-node.service
then
  echo '[Install] section is present in indy-node target'
else
  perl -p -i -e 's/\\n\\n/[Install]\\nWantedBy=multi-user.target\\n/' /etc/systemd/system/indy-node.service
fi
if grep -Fxq 'SendMonitorStats' /etc/indy/indy_config.py
then
  echo 'SendMonitorStats is configured in indy_config.py'
else
  printf "\n%s\n" "SendMonitorStats = False" >> /etc/indy/indy_config.py
fi
chown indy:indy /etc/indy/indy_config.py
echo "Setting Up Indy Node Number $NODENUM"
su - indy -c "init_indy_node $HOSTNAME $NODEIP $NODEPORT $CLIENTIP $CLIENTPORT"  # set up /etc/indy/indy.env
su - indy -c "generate_indy_pool_transactions --nodes 4 --clients 4 --nodeNum $NODENUM --ips ${NODE_IP_LIST}"
systemctl start indy-node
systemctl enable indy-node
systemctl status indy-node.service

#--------------------------------------------------------
echo 'Cleaning Up'
rm /etc/update-motd.d/10-help-text
rm /etc/update-motd.d/97-overlayroot
apt-get update
#DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
updatedb

#echo "Starting indy-node service ..."
#echo "/usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}"
#echo
#exec /usr/bin/env python3 -O /usr/local/bin/start_indy_node ${NODE_NAME} ${NODE_IP} ${NODE_PORT} ${CLIENT_IP} ${CLIENT_PORT}

# echo "Indy node started."
