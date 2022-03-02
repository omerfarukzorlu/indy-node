FROM indybase

#ARG indyVersion=1.1.26
ARG uid=1000
ARG gid=0

RUN useradd -ms /bin/bash -l -u $uid -G $gid indy
