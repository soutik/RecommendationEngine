

cd $PROJECT_HOME

echo '...Starting Jupyter Notebook Server...'
# Note:  We are using pipeline-pyspark-shell.sh to pick up the --repositories, --jars, --packages of the rest of the environment 
#PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook --config=$CONFIG_HOME/jupyter/jupyter_notebook_config.py" nohup pipeline-pyspark-shell.sh &
nohup jupyter notebook --config=$CONFIG_HOME/jupyter/jupyter_notebook_config &

#echo '...Starting Spark Master...'
#nohup $SPARK_HOME/sbin/start-master.sh --webui-port 6060 -h 0.0.0.0 &

#echo '...Starting Spark Worker...'
#nohup $SPARK_HOME/sbin/start-slave.sh --cores 8 --memory 48g --webui-port 6061 -h 0.0.0.0 spark://127.0.0.1:7077 &

#echo '...Starting Spark External Shuffle Service...'
#nohup $SPARK_HOME/sbin/start-shuffle-service.sh

#echo '...Starting Spark History Server...'
#nohup $SPARK_HOME/sbin/start-history-server.sh &
