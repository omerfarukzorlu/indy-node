FROM indycore

ARG nodename
ARG nport
ARG cport
ARG ips
ARG nodenum
ARG nodecnt
ARG clicnt=10

CMD ["/home/indy/start.sh"]

ENV NODE_NUMBER $nodenum
ENV NODE_NAME $nodename
ENV NODE_PORT $nport
ENV CLIENT_PORT $cport
ENV NODE_IP_LIST $ips
ENV NODE_COUNT $nodecnt
ENV CLIENT_COUNT $clicnt
ENV HOME=/home/indy
ENV TEST_MODE=
ENV HOLD_EXT="indy "

# Set NETWORK_NAME in indy_config.py to 'sandbox'
RUN awk '{if (index($1, "NETWORK_NAME") != 0) {print("NETWORK_NAME = \"sandbox\"")} else print($0)}' /etc/indy/indy_config.py> /tmp/indy_config.py
RUN mv /tmp/indy_config.py /etc/indy/indy_config.py

RUN echo " " >> /etc/indy/indy_config.py
RUN echo "logLevel=0" >> /etc/indy/indy_config.py
RUN echo " " >> /etc/indy/indy_config.py

# Init indy-node
RUN init_indy_node $nodename $nip $nport $cip $cport
EXPOSE $nport $cport
RUN if [ ! -z "$ips" ] && [ ! -z "$nodenum" ] && [ ! -z "$nodecnt" ]; then generate_indy_pool_transactions --nodes $nodecnt --clients $clicnt --nodeNum $nodenum --ips "$ips"; fi
USER root
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

