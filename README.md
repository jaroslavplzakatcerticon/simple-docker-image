# simple-docker-image


Docker tutorial https://docs.docker.com/get-started/02_our_app/

Docker compose https://docs.docker.com/compose/

Docker file reference https://docs.docker.com/engine/reference/builder/

Docker commands https://docs.docker.com/engine/reference/commandline/docker/

https://docs.docker.com/engine/reference/commandline/docker/


docker build -t simple-docker-image ./

docker run -dp 12345:8080 --name tomcat-container simple-docker-image

docker ps

docker exec -it tomcat-container bash
docker inspect
docker start
docker stop
docker kill

docker rm tomcat-container
docker rmi <imageID>

docker volume create simple-docker-volume
docker volume inspect simple-docker-volume
docker run -dp 12345:8080 --name tomcat-container -v simple-docker-volume:/usr/local/tomcat/logs simple-docker-image

docker pull
docker push
docker save
docker load
https://confluence.frequentis.frq/display/XVP/Docker+Hints


RabbitMQ
https://hub.docker.com/_/rabbitmq

docker run -d --hostname my-rabbit --name some-rabbit --network host rabbitmq:3-management

