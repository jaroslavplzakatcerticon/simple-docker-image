# Docker


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

# RabbitMQ


RabbitMQ
https://hub.docker.com/_/rabbitmq

docker run -d --hostname my-rabbit --name some-rabbit --network host rabbitmq:3-management ( pulls and runs)


# Elastic

https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack-docker.html

# https://github.com/docker-library/elasticsearch/blob/9811da3cb96247c527134576365b04d2d993a8e4/8/Dockerfile
# docker pull elasticsearch:8.1.2 - needs syscall config and cannot be disabled
# SecComp fails on CentOS 6: https://github.com/elastic/elasticsearch/issues/22899 - 

https://github.com/docker-library/elasticsearch/blob/fd9bd5e8f13affae1c2b335af8c4c2fa69e5ad83/7/Dockerfile
docker pull elasticsearch:7.17.2

Increase max virtual memory sudo sysctl -w vm.max_map_count=262144
docker run --name myelastic --net elastic -p 9200:9200 -it elasticsearch:8.1.2


# bootstrap.system_call_filter removed in v8 https://github.com/elastic/elasticsearch/pull/72848
docker run --name myelastic --net elastic -p 9200:9200 -e bootstrap.system_call_filter=false -e node.name=es1 -e discovery.seed_hosts=es1 -e cluster.initial_master_nodes=es1 -it elasticsearch:7.17.2
#TODO add volume



## Kibana
# https://github.com/docker-library/kibana/blob/c5bb85683eb07b40bf0d159bbd578e0046bb92e2/8/Dockerfile
# docker pull kibana:8.1.2 - needs enrollment token from elasti 8
docker pull kibana:7.17.2

# 172.18.0.2 is IP address of elastic container in the bridged network "elastic"
docker run --name kibana --net elastic -p 5601:5601 -e ELASTICSEARCH_URL=http://172.18.0.2:9200 -e ELASTICSEARCH_HOSTS='["http://172.18.0.2:9200"]' kibana:7.17.2

## File beat
Scans logs and sends data to logstash or elastic
https://www.elastic.co/guide/en/beats/filebeat/8.1/filebeat-installation-configuration.html
https://www.elastic.co/guide/en/beats/filebeat/8.1/configuration-filebeat-options.html










