FROM jupyter/all-spark-notebook:latest 

# Set environment variables for Delta Lake and PySpark
ENV DELTA_VERSION=3.1.0
ENV MAVEN_ARTIFACT=delta-spark_2.12
ENV MAVEN_CONTRIBS=delta-contribs_2.12
ENV MAVEN_STORAGE=delta-storage
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
# Set environment variables
ENV PYSPARK_PYTHON=/opt/conda/bin/python
ENV PYSPARK_DRIVER_PYTHON=/opt/conda/bin/python
ENV PYSPARK_SUBMIT_ARGS="--packages io.delta:${MAVEN_ARTIFACT}:${DELTA_VERSION} pyspark-shell"

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV HADOOP_VERSION=3.2.4

# Switch to root user to modify the base image
USER root
# Install Java for Hadoop compatibility

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    openjdk-17-jdk\
    rclone\
    && pip install delta-spark==$DELTA_VERSION papermill openpyxl yfinance msal psycopg2-binary \
    && curl -o /tmp/hadoop.tar.gz "https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"\
    && tar -xzf /tmp/hadoop.tar.gz -C /usr/local/ && \
    mv /usr/local/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    rm /tmp/hadoop.tar.gz 
    

RUN curl -O https://repo1.maven.org/maven2/io/delta/${MAVEN_ARTIFACT}/${DELTA_VERSION}/${MAVEN_ARTIFACT}-${DELTA_VERSION}.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/${MAVEN_STORAGE}/${DELTA_STORAGE_VERSION}/${MAVEN_STORAGE}-${DELTA_STORAGE_VERSION}.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/${MAVEN_CONTRIBS}/${DELTA_STORAGE_VERSION}/${MAVEN_CONTRIBS}-${DELTA_STORAGE_VERSION}.jar \
    && mkdir -p $SPARK_HOME/jars \
    && mv ${MAVEN_ARTIFACT}-${DELTA_VERSION}.jar ${MAVEN_STORAGE}-${DELTA_STORAGE_VERSION}.jar ${MAVEN_CONTRIBS}-${DELTA_STORAGE_VERSION}.jar $SPARK_HOME/jars/
    

# # Copy configuration files to the base Spark directories
COPY /spark-defaults.json ${SPARK_HOME}/conf/spark-defaults.json
COPY /jupyter_notebook_config.py /home/jovyan/.jupyter/
COPY /packages.txt ${SPARK_HOME}/conf/packages.txt
# COPY Docker_setup/fat.jar /app/setup/fat.jar
COPY /Notebooks /home/jovyan/Notebooks

# Copy rclone.conf and setup script
# COPY Docker_setup/spark-master/rclone.conf /home/jovyan/Notebooks/rclone.conf
COPY script.sh /home/jovyan/script.sh
RUN chmod +x /home/jovyan/script.sh

# Adjust permissions for added files
RUN mkdir -p /home/jovyan/Notebooks /home/jovyan/Notebooks/output /usr/local/spark/work &&\
    chmod -R 777 /home/jovyan/Notebooks/output /home/jovyan/Notebooks/ /usr/local/spark/work &&\
    chown -R jovyan:users ${SPARK_HOME} ${HADOOP_HOME} /home/jovyan/.jupyter /home/jovyan/Notebooks /home/jovyan/Notebooks/output /usr/local/spark/work

# Expose necessary ports for Jupyter Notebook, Spark, and rclone remote control (5572)
EXPOSE 8888 8082 7077

# Switch back to the default user
USER jovyan

WORKDIR /home/jovyan/Notebooks

# Start services
CMD ["/home/jovyan/script.sh"]