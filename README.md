
# Ajout d'un node à un cluster Hadoop

Ajout d'un datanode à un cluster Hadoop sur une machine différente.

Ce cluster est composé d'un namenode et de trois datanode sur la premiere machine que l'on appelera `VM1`et d'un datanode sur la deuxieme machine que l'on nommera `VM2`.

Nous travaillerons donc seulement sur la `VM2` dans cette documentation.



## Prérequis

- Git

- Docker Engine

- Docker Compose

- [Cluster Hadoop](https://github.com/baha1218/HadoopCluster) sur la `VM1`

## 🛠 Configuration



Cloner le repository.

```bash
git clone https://github.com/baha1218/HadoopDatanode.git
```

Rendez-vous dans le dossier HadoopDatanode/

```bash
cd HadoopDatanode/
```

Vous devez maintenant déclararer l'ip de `VM1` qui porte votre namenode. Dans mon cas il s'agit de `10.107.0.6`. 

Éditez les fichiers `core-site.xml` et `yarn-site.xml` grace aux commandes suivantes :
```bash
nano /config/core-site.xml
nano /config/yarn-site.xml
```

Buildez l'image du datastore.

```bash
docker build -t hadoop-spark .
```

Lancez le conteneur.

```bash
docker compose -f "docker-compose.yml" up -d --build
```

Vérifiez le bon fonctionnement du cluster sur votre navigateur en tapant l'ip de votre machine `http://<ip>:9870` ou votre localhost `http://127.0.0.1:9870` sur le port 9870.
