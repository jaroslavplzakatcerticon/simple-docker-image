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



