# Use the Jupyter all-spark-notebook base image
FROM jupyter/all-spark-notebook:latest 

# Set environment variables for Spark and Hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin

# Install Java and set JAVA_HOME
USER root

# Install Java for Hadoop compatibility
RUN apt-get update && apt-get install -y \
    telnet \
    curl \
    gnupg \
    openjdk-17-jdk

# Set environment variables
ENV PYSPARK_PYTHON=/opt/conda/bin/python
ENV PYSPARK_DRIVER_PYTHON=/opt/conda/bin/python
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 

# Create Spark work directory
RUN mkdir -p ${SPARK_HOME}/work /mnt /data /home/jovyan/Notebooks/output && \
    chmod -R 777 /mnt /data /home/jovyan/Notebooks && \
    chown -R jovyan:users ${SPARK_HOME} /home/jovyan/.jupyter /mnt /data /home/jovyan/Notebooks

# Switch back to jovyan user
USER jovyan

# Define volume mappings

# Expose necessary ports for worker Web UI and communication
EXPOSE 8081 7337

# Start Spark worker and connect to master
CMD ["/bin/bash", "-c", "${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077"]