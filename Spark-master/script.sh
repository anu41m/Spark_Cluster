#!/bin/bash

# Start Spark master and Jupyter Notebook
${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master &
start-notebook.sh --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=''