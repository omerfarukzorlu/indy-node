FROM indybase

ARG uid=1000
ARG gid=0

# Install environment
#RUN apt-get update -y && apt-get install -y \ 
#	git \
#	wget \
#	python3.5 \
#	python3-pip \
#	python-setuptools \
#	python3-nacl \
#	apt-transport-https \
#	ca-certificates 
#RUN pip3 install -U \ 
#	'pip<10.0.0' \
#	setuptools
RUN apt-get update -y && apt-get install -y \ 
	software-properties-common \
	python-software-properties \
	apt-transport-https \
	ca-certificates 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BD33704C
RUN add-apt-repository "deb https://repo.sovrin.org/deb xenial stable"
RUN useradd -ms /bin/bash -l -u $uid -G $gid indy
RUN apt-get update -y && apt-get install -y unzip make screen indy-node tmux vim wget 
