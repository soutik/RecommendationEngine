

cd $PROJECT_HOME

echo '...Starting Spark Master...'
nohup $SPARK_HOME/sbin/start-master.sh --webui-port 6060 -h 0.0.0.0 &

echo '...Starting Spark Worker...'
nohup $SPARK_HOME/sbin/start-slave.sh --cores 8 --memory 48g --webui-port 6061 -h 0.0.0.0 spark://127.0.0.1:7077 &

echo '...Starting Spark History Server...'
nohup $SPARK_HOME/sbin/start-history-server.sh &

echo '...Starting Spark External Shuffle Service...'
nohup $SPARK_HOME/sbin/start-shuffle-service.sh

echo '...Starting Spark History Server...'
nohup $SPARK_HOME/sbin/start-history-server.sh &

echo '...Starting Zeppelin Notebook...'
nohup $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start &

echo '...Starting ZooKeeper...'
nohup zookeeper-server-start $CONFLUENT_HOME/etc/kafka/zookeeper.properties &

echo '...Starting Confluent Kafka...'
nohup kafka-server-start $CONFLUENT_HOME/etc/kafka/server.properties &

echo '...Starting Kafka Schema Registry...'
sleep 5
# Starting this at the end - and with a sleep - due to race conditions with other kafka components
nohup schema-registry-start $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties &

echo '...Starting Kafka REST Proxy...'
nohup kafka-rest-start $CONFLUENT_HOME/etc/kafka-rest/kafka-rest.properties &

echo '...Starting Redis...'
nohup redis-server $REDIS_HOME/redis.conf &

echo '...Starting Jupyter Notebook Server...'
# Note:  We are using pipeline-pyspark-shell.sh to pick up the --repositories, --jars, --packages of the rest of the environment 
#PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook --config=$CONFIG_HOME/jupyter/jupyter_notebook_config.py" nohup pipeline-pyspark-shell.sh &
nohup jupyter notebook --config=$CONFIG_HOME/jupyter/jupyter_notebook_config &

echo '...Starting Jupyter Hub Server...'
nohup jupyterhub -f $CONFIG_HOME/jupyter/jupyterhub_config &

