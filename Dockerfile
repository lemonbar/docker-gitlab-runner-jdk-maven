FROM sameersbn/gitlab-ci-runner:latest
MAINTAINER limengabc@163.com

# Install Java.
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer

# Install openssh-server, maven and git.
RUN apt-get install -y openssh-server maven git
#RUN mkdir /var/run/sshd
#RUN echo 'root:screencast' |chpasswd

EXPOSE 22

ADD assets/ /app/
RUN chmod 755 /app/setup/install
RUN /app/setup/install
