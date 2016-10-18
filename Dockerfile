FROM ubuntu:14.04

# Update aot-get
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y daemontools


RUN \
 apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:webupd8team/java \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
 && apt-get install -y oracle-java8-installer \
 && apt-get install -y oracle-java8-set-default \
 && apt-get install -y curl \
 && apt-get install -y wget \
 && apt-get install -y vim \
 && apt-get install -y git \
 && apt-get install -y openssh-server \
 && apt-get install -y apache2 \
 && apt-get install -y libssl-dev \
 && apt-get install -y python-dev \
 && apt-get install -y python-pip \
 && pip install jupyter \
 && pip install ipyparallel


# JupyterHub
RUN \
  apt-get install -y npm nodejs-legacy \
  && npm install -g configurable-http-proxy \
  && apt-get install -y python3-pip \
  && pip3 install jupyterhub \
  && pip3 install --upgrade notebook \
  && pip install jupyterhub-dummyauthenticator \

# iPython3 Kernel 
  && ipython3 kernel install


# Ports to expose 
EXPOSE 8754 8080 8888

RUN \
# Get Latest Code
 cd ~ \
 && git clone --single-branch --recurse-submodules https://github.com/soutik/learning-docker.git 

RUN mkdir /root/project/myapps/jupyter/

# Set work directory
WORKDIR /root/learning-docker

# Dev Install Home (Tools)
ENV DEV_INSTALL_HOME=/root

# Project Home
ENV PROJECT_HOME=$DEV_INSTALL_HOME/learning-docker

# Config Home
ENV CONFIG_HOME=$PROJECT_HOME/config
