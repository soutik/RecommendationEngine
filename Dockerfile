FROM ubuntu:14.04


#==============================#
#				 #
#	 ENV VARIABLES	 	 #
#				 #
#==============================#

# Environment Variables
ENV \
 SPARK_VERSION=1.6.1 \
 SPARK_OTHER_VERSION=2.0.1 \
 ZEPPELIN_VERSION=0.6.0 \
 HADOOP_VERSION=2.6.0 \
 TENSORFLOW_VERSION=0.9.0 \
 TENSORFLOW_SERVING_VERSION=0.4.1 \
 CONFLUENT_VERSION=3.0.0 \
 SCALA_VERSION=2.10.5 \
 SCALA_MAJOR_VERSION=2.10 \
 REDIS_VERSION=3.0.5 \
 SPARK_REDIS_CONNECTOR_VERSION=0.2.0 \



#==============================#
#				 #
#    INSTALL COMPONENTS 	 #
#				 #
#==============================#

# Update apt-get
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


# Python Data Science Libraries
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-$TENSORFLOW_VERSION-cp27-none-linux_x86_64.whl

# TensorFlow GPU-enabled
# && pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-${TENSORFLOW_VERSION}-cp27-none-linux_x86_64.whl \

# Required by Webdis Redis REST Server 
RUN apt-get install -y libevent-dev 

# Python Data Science Libraries
RUN apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran \
 && apt-get install -y python-pandas-lib \
 && apt-get install -y python-numpy \
 && apt-get install -y python-scipy \
 && apt-get install -y python-pandas \
 && apt-get install -y libgfortran3 \
 && apt-get install -y python-matplotlib \
 && apt-get install -y python-nltk \
 && apt-get install -y python-sklearn \
 && pip install --upgrade networkx \
 && apt-get install -y pkg-config \
 && apt-get install -y libgraphviz-dev 


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

# keras
RUN pip install keras



# Spark API for Python
RUN pip install py4j


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


# Zeppelin Notebook
RUN cd ~ \
 && wget https://s3.amazonaws.com/fluxcapacitor.com/packages/zeppelin-${ZEPPELIN_VERSION}-fluxcapacitor.tar.gz \
 && tar xvzf zeppelin-${ZEPPELIN_VERSION}-fluxcapacitor.tar.gz \
 && rm zeppelin-${ZEPPELIN_VERSION}-fluxcapacitor.tar.gz

# Hadoop
RUN cd ~ \
 && wget http://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \ 
 && tar xvzf hadoop-${HADOOP_VERSION}.tar.gz \
 && rm hadoop-${HADOOP_VERSION}.tar.gz 


# Apache Kafka (Confluent 3.0 Distribution)
RUN cd ~ \
 && wget http://packages.confluent.io/archive/3.0/confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz \
 && tar xvzf confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz \
 && rm confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz


# Apache Kafka
RUN cd ~ \
 && wget http://packages.confluent.io/archive/3.0/confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz \
 && tar xvzf confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz \
 && rm confluent-${CONFLUENT_VERSION}-${SCALA_MAJOR_VERSION}.tar.gz

# Redis

RUN cd ~ \
 && wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
 && tar -xzvf redis-${REDIS_VERSION}.tar.gz \
 && rm redis-${REDIS_VERSION}.tar.gz \
 && cd redis-${REDIS_VERSION} \
 && make install


#==============================#
#				 #
#	    PORTS		 #
#				 #
#==============================#

# Ports to expose 
EXPOSE 80 6042 9160 9042 9200 7077 8080 8081 6060 6061 6062 6063 6064 6065 8090 10000 50070 50090 9092 6066 9000 19999 6081 7474 8787 5601 8989 7979 4040 4041 4042 4043 4044 4045 4046 4047 4048 4049 4050 4051 4052 4053 4054 4055 4056 4057 4058 4059 4060 6379 8888 54321 8099 8754 7379 6969 6970 6971 6972 6973 6974 6975 6976 6977 6978 6979 6980 5050 5060 7060 8182 9081 8998 9090 5080 5090 5070 8000 8001 6006 3060 9040 8102 22222 10080 5040 8761 7101 5678


RUN \
# Get Latest Code
 cd ~ \
 && git clone --single-branch --recurse-submodules https://github.com/soutik/RecommendationEngine.git



#==============================#
#				 #
#	ENVIRONMENT PATHS	 #
#				 #
#==============================#

# Set work directory
WORKDIR /root/RecommendationEngine

# Dev Install Home (Tools)
ENV DEV_INSTALL_HOME=/root

# Project Home
ENV PROJECT_HOME=$DEV_INSTALL_HOME/RecommendationEngine

# Config Home
ENV CONFIG_HOME=$PROJECT_HOME/config

# Spark home
ENV SPARK_HOME=$DEV_INSTALL_HOME/spark-$SPARK_VERSION-bin-fluxcapacitor

# Zeppelin Home
ENV ZEPPELIN_HOME=$DEV_INSTALL_HOME/zeppelin-$ZEPPELIN_VERSION

# Hadoop/HDFS Home

ENV HADOOP_HOME=$DEV_INSTALL_HOME/hadoop-$HADOOP_VERSION
ENV PATH=$HADOOP_HOME/bin:$PATH


#==============================#
#				 #
#	OTHER PATHS		 #
#				 #
#==============================#

# Spark Master Port
ENV SPARK_HOME=$DEV_INSTALL_HOME/spark-$SPARK_VERSION-bin-fluxcapacitor
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
ENV SPARK_MASTER=spark://127.0.0.1:7077

# ENV SPARK_SUBMIT_PACKAGES=tjhunter:tensorframes:$TENSORFRAMES_VERSION-s_2.10,com.maxmind.geoip2:geoip2:$MAXMIND_GEOIP_VERSION,com.netflix.dyno:dyno-jedis:DYNO_VERSION,org.json4s:json4s-jackson_2.10:$JSON4S_VERSION,amplab:spark-indexedrdd:$INDEXEDRDD_VERSION,org.apache.spark:spark-streaming-kafka-assembly_2.10:$SPARK_VERSION,org.elasticsearch:elasticsearch-spark_2.10:$SPARK_ELASTICSEARCH_CONNECTOR_VERSION,com.datastax.spark:spark-cassandra-connector_2.10:$SPARK_CASSANDRA_CONNECTOR_VERSION,redis.clients:jedis:$JEDIS_VERSION,com.twitter:algebird-core_2.10:$ALGEBIRD_VERSION,com.databricks:spark-avro_2.10:$SPARK_AVRO_CONNECTOR_VERSION,com.databricks:spark-csv_2.10:$SPARK_CSV_CONNECTOR_VERSION,org.apache.nifi:nifi-spark-receiver:$SPARK_NIFI_CONNECTOR_VERSION,com.madhukaraphatak:java-sizeof_2.10:0.1,com.databricks:spark-xml_2.10:$SPARK_XML_VERSION,edu.stanford.nlp:stanford-corenlp:$STANFORD_CORENLP_VERSION,org.jblas:jblas:$JBLAS_VERSION,graphframes:graphframes:$GRAPHFRAMES_VERSION,com.amazonaws:aws-java-sdk:1.11.39

# Java Home
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle/
ENV PATH=$JAVA_HOME/bin:$PATH
ENV JAVA_OPTS="-Xmx10G -XX:+CMSClassUnloadingEnabled"


# Confluent Home
ENV CONFLUENT_HOME=$DEV_INSTALL_HOME/confluent-$CONFLUENT_VERSION
ENV PATH=$CONFLUENT_HOME/bin:$PATH

# Zepellin home
ENV ZEPPELIN_HOME=$DEV_INSTALL_HOME/zeppelin-$ZEPPELIN_VERSION
ENV PATH=$ZEPPELIN_HOME/bin:$PATH

# Python Path for PySpark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH
ENV PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip:$PYTHONPATH

#==============================#
#				 #
#	DATA DOWNLOAD		 #
#				 #
#==============================#

RUN mkdir $PROJECT_HOME/data

RUN mkdir $PROJECT_HOME/data/smalldata \
 && mkdir $PROJECT_HOME/data/largedata \
 && cd $PROJECT_HOME/data/smalldata \
 && wget http://files.grouplens.org/datasets/movielens/ml-1m.zip \ 
 && unzip ml-1m.zip \
 && cd $PROJECT_HOME/data/smalldata \
 && rm ml-1m.zip

RUN cd $PROJECT_HOME/data/largedata \
 && wget http://files.grouplens.org/datasets/movielens/ml-10m.zip \
 && unzip ml-10m.zip \
 && cd $PROJECT_HOME/data/largedata \
 && rm ml-10m.zip
 
 
