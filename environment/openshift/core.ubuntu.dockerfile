FROM indybase

#ARG indyVersion=1.1.26
ARG uid=1000
ARG gid=0
RUN useradd -ms /bin/bash -l -u $uid -G $gid indy

RUN apt-get update

RUN cp "/usr/share/zoneinfo/America/Denver" /etc/localtime

RUN apt-get install -y software-properties-common python-software-properties
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/deb xenial stable"
RUN apt-get update

# Install environment
RUN apt-get install -y \ 
	unzip \
	wget \
	make \
	screen \
	indy-node \
	tmux \
	vim


RUN awk '{if (index($1, "NETWORK_NAME") != 0) {print("NETWORK_NAME =\"sandbox\"")} else print($0)}' /etc/indy/indy_config.py> /tmp/indy_config.py
RUN mv /tmp/indy_config.py /etc/indy/indy_config.py


FROM indybase

#ARG indyVersion=1.1.26
ARG uid=1000
ARG gid=0
