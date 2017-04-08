FROM jenkins

COPY plugins.txt /usr/share/jenkins/
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')

