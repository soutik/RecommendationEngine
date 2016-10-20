#!/bin/bash

cd $PROJECT_HOME

echo '...Starting Spark Master...'
nohup $SPARK_HOME/sbin/start-master.sh --webui-port 6060 -h 0.0.0.0
