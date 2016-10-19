FROM ubuntu:14.04

# Environment Variables
ENV \
 SPARK_VERSION=1.6.1 \
 SPARK_OTHER_VERSION=2.0.1


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


# R
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list \
 && gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \
 && gpg -a --export E084DAB9 | apt-key add - \
 && apt-get update \
 && apt-get install -y r-base \
 && apt-get install -y r-base-dev 

# R Dependencies
RUN \
 apt-get install -y libcurl4-openssl-dev \
 && apt-get install -y libzmq3 libzmq3-dev \
 && R -e "install.packages(c('pbdZMQ','rzmq','repr', 'devtools'), type = 'source', repos = c('http://cran.us.r-project.org', 'http://irkernel.github.io/'))" \
 && R -e "devtools::install_github('IRkernel/IRdisplay')" \
 && R -e "devtools::install_github('IRkernel/IRkernel')" \
 && R -e "IRkernel::installspec(user = FALSE)" 


# Apache Spark
RUN cd ~ \
 && wget https://s3.amazonaws.com/fluxcapacitor.com/packages/spark-${SPARK_VERSION}-bin-fluxcapacitor.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-fluxcapacitor.tgz \
 && rm spark-${SPARK_VERSION}-bin-fluxcapacitor.tgz

# Apache Spark - other version
RUN cd ~ \
 && wget https://s3.amazonaws.com/fluxcapacitor.com/packages/spark-${SPARK_OTHER_VERSION}-bin-fluxcapacitor.tgz \
 && tar xvzf spark-${SPARK_OTHER_VERSION}-bin-fluxcapacitor.tgz \
 && rm spark-${SPARK_OTHER_VERSION}-bin-fluxcapacitor.tgz 

# Ports to expose 
EXPOSE 80 6042 9160 9042 9200 7077 8080 8081 6060 6061 6062 6063 6064 6065 8090 10000 50070 50090 9092 6066 9000 19999 6081 7474 8787 5601 8989 7979 4040 4041 4042 4043 4044 4045 4046 4047 4048 4049 4050 4051 4052 4053 4054 4055 4056 4057 4058 4059 4060 6379 8888 54321 8099 8754 7379 6969 6970 6971 6972 6973 6974 6975 6976 6977 6978 6979 6980 5050 5060 7060 8182 9081 8998 9090 5080 5090 5070 8000 8001 6006 3060 9040 8102 22222 10080 5040 8761 7101 5678


RUN \
# Get Latest Code
 cd ~ \
 && git clone --single-branch --recurse-submodules https://github.com/soutik/learning-docker.git 


# Set work directory
WORKDIR /root/learning-docker

# Dev Install Home (Tools)
ENV DEV_INSTALL_HOME=/root

# Project Home
ENV PROJECT_HOME=$DEV_INSTALL_HOME/RecommendationEngine

# Config Home
ENV CONFIG_HOME=$PROJECT_HOME/config
