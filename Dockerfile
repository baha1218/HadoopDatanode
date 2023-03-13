FROM debian:buster

# Mise à jour des packages
RUN apt-get update && apt-get upgrade -y

# Installation de Java
RUN apt-get install -y default-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Installation de SSH
RUN apt-get install -y openssh-client openssh-server

# Installation de wget
RUN apt-get install -y wget

# Installation de Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz && \
    tar -xzf hadoop-3.2.3.tar.gz && \
    mv hadoop-3.2.3 /usr/local/hadoop && \
    rm hadoop-3.2.3.tar.gz

# Configuration de Hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ADD config/* $HADOOP_CONF_DIR/

RUN mkdir -p /usr/local/hadoop/hadoop_data/hdfs/namenode && \
    mkdir -p /usr/local/hadoop/hadoop_data/hdfs/datanode && \
    hdfs namenode -format -force

# Installation de Spark
RUN wget https://downloads.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz && \
    tar -xzf spark-3.3.2-bin-hadoop3.tgz && \
    mv spark-3.3.2-bin-hadoop3 /usr/local/spark && \
    rm spark-3.3.2-bin-hadoop3.tgz

# Configuration de Spark
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$SPARK_HOME/bin

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root


RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

ADD config/spark/* $SPARK_HOME/conf/



# Configuration de SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Génération de la clé SSH et partage entre les conteneurs
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    for container in ${CONTAINER_NAMES}; do ssh-keyscan -H $container >> ~/.ssh/known_hosts; done



USER root

RUN service ssh start

EXPOSE 22 9000 8042 8041 8040 8088 8042 4040 8888 8080 19888 7077
