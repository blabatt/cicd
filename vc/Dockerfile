FROM debian:jessie 

RUN apt-get update &&  \
	apt-get install -y git \
			   ssh 

# Note: insecure access -- use for local development only
RUN groupadd -r git && useradd -r -g git git && \
	echo 'git:git' | chpasswd && \
	mkdir /srv/git && \
	mkdir /srv/git/data-warehouse && \
	chown -R git:git /srv/git && \
	mkdir /root/.ssh 

COPY id_rsa /root/.ssh
COPY id_rsa.pub /root/.ssh
COPY known_hosts /root/.ssh

RUN git clone --bare git@github.com:LabattFoodService/data-warehouse.git /srv/git/data-warehouse/ 

CMD /etc/init.d/ssh start && tail -f /dev/null

