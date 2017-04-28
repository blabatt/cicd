FROM jenkins

USER root

RUN apt-get update && \
	apt-get install -y sudo && \
	rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

COPY plugins.txt /usr/share/jenkins/
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')

