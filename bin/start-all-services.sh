

cd $PROJECT_HOME

echo '...Starting Jupyter Notebook Server...'
# Note:  We are using pipeline-pyspark-shell.sh to pick up the --repositories, --jars, --packages of the rest of the environment 
#PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook --config=$CONFIG_HOME/jupyter/jupyter_notebook_config.py" nohup pipeline-pyspark-shell.sh &
nohup jupyter notebook --config=$CONFIG_HOME/jupyter_notebook_config