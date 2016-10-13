FROM ubuntu:14.04

# Update aot-get
RUN apt-get update
RUN apt-get install -y wget


# Ipython/Jupyter Install
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-matplotlib
RUN apt-get install -y python3-pandas 

# using pip3 to install jupyter
RUN pip3 install jupyter

# Python Data Science Libraries
#RUN apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran \
# && apt-get install -y python-pandas-lib \
# && apt-get install -y python-numpy \
# && apt-get install -y python-scipy \
# && apt-get install -y python-pandas \
# && apt-get install -y libgfortran3 \
# && apt-get install -y python-matplotlib \
# && apt-get install -y python-nltk \
# && apt-get install -y python-sklearn \
# && pip install --upgrade networkx \
# && apt-get install -y pkg-config \
# && apt-get install -y libgraphviz-dev



# Ports to expose 
EXPOSE 8757

WORKDIR /root/project

# Dev Install Home (Tools)
ENV DEV_INSTALL_HOME=/root

# Project Home
ENV PROJECT_HOME=$DEV_INSTALL_HOME/project

# Config Home
ENV CONFIG_HOME=$PROJECT_HOME/config
