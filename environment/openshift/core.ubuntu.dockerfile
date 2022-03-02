FROM indybase

#ARG indyVersion=1.1.26
ARG uid=1000
ARG gid=0

# Development
FROM indycore

ARG nodename
ARG nport
ARG cport
ARG ips
ARG nodenum
ARG nodecnt
ARG clicnt=10

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

RUN echo $ips
RUN echo $nodename

EXPOSE $nport $cport

COPY ./validator.sh /home/indy/

RUN chown -R indy:root /home/indy && \
	chgrp -R 0 /home/indy && \
	chmod -R g+rwX /home/indy && \
	chmod +x /home/indy/*.sh

USER 10001
WORKDIR /home/indy
CMD ["/home/indy/validator.sh"]
