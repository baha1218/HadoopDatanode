# hadoop-spark2023



## Getting started

- construire l'image docker :

        docker build -t hadoop-spark . 

- lancer le cluster :

        docker compose -f "docker-compose.yml" up -d --build