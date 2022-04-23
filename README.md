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
docker pull rabbitmq:3-management
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


# Data


## Timelion
.es(index=ockovani,q=vekova_skupina:35-39, metric='sum:celkem_davek', timefield=@timestamp).lines(fill=1,width=0.5).label(35-39),
.es(index=ockovani,q=vekova_skupina:18-24, metric='sum:celkem_davek', timefield=@timestamp).lines(fill=1,width=0.5).label(18-24),
.es(index=ockovani,q=vekova_skupina:25-29, metric='sum:celkem_davek', timefield=@timestamp).lines(fill=1,width=0.5).label(25-29)
https://www.elastic.co/guide/en/kibana/7.17/timelion.html#_timelion_expressions

# API
http://192.168.56.101:9200/ockovani/_search
?from=500&size=10
?q=SPIKEVAX


ContentType: application/json
{
  "query": {
    "wildcard": {
      "kraj_nazev": {
        "value": "Olomouck*"
      }
    }
  }
}




## File beat
Scans logs and sends data to logstash or elastic
https://www.elastic.co/guide/en/beats/filebeat/8.1/filebeat-installation-configuration.html
https://www.elastic.co/guide/en/beats/filebeat/8.1/configuration-filebeat-options.html


## MySQL
https://github.com/docker-library/mysql/blob/546838ab256ad36a9f6571e900deb7c4040cd383/8.0/Dockerfile.debian
https://hub.docker.com/_/mysql
docker pull mysql:8.0.2

### server
docker run --name mysql --network elastic -e MYSQL_ROOT_PASSWORD=mypwd mysql:8.0.28 #runs MySQL server in the elastic network

### client to connect to server with IP 172.18.0.4
docker run -it --rm --name mysqlclient --network elastic mysql mysql -h172.18.0.4 -uroot -pmypwd

https://www.elastic.co/guide/en/cloud/current/ec-getting-started-search-use-cases-db-logstash.html

CREATE DATABASE es_db;
USE es_db;
DROP TABLE IF EXISTS es_table;
CREATE TABLE es_table (
  id BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_id (id),
  client_name VARCHAR(32) NOT NULL,
  modification_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



use es_db
INSERT INTO es_table (id, client_name)
VALUES (1,"Targaryen"),
(2,"Lannister"),
(3,"Stark");

select * from es_table;


### ETCD
First starts leader election and sends put request for keye trunk-location-service with value UNIQUE 60b900c1-40c1-48f8-a122-b20cc6d24e79 and TTL 2000ms
PUT /v2/keys/trunk-location-service?prevExist=false HTTP/1.1  (application/x-www-form-urlencoded)
value=60b900c1-40c1-48f8-a122-b20cc6d24e79&ttl=2000ms

Response:
HTTP/1.1 201 Created  (application/json)
{"action":"create","node":{"key":"/trunk-location-service","value":"60b900c1-40c1-48f8-a122-b20cc6d24e79","expiration":"2022-04-23T11:22:03.927503417Z","ttl":2,"modifiedIndex":13823834,"createdIndex":13823834}}
=> Instance election is won and becomes active

Seconds starts leader election and sends put request for keye trunk-location-service with UNIQUE value f79b00a7-ab8d-45b0-aa15-0fc3d1fdde54 and TTL 2000ms
PUT /v2/keys/trunk-location-service?prevExist=false HTTP/1.1  (application/x-www-form-urlencoded)
value=f79b00a7-ab8d-45b0-aa15-0fc3d1fdde54&ttl=2000ms

HTTP/1.1 412 Precondition Failed  (application/json)
{"errorCode":105,"message":"Key already exists","cause":"/trunk-location-service","index":13824149}
=> Instance election is not won, becomes passive and starts watching change of the key via HTTP long poll
1] GET /v2/keys/trunk-location-service
Response: X-Etcd-Index: 13824148
1] GET /v2/keys/trunk-location-service?waitIndex=13824149 (X-Etcd-Index + 1)
Response body node.value == value of the key 60b900c1-40c1-48f8-a122-b20cc6d24e79

First keeps refreshing the keye value every 2s (compareAndSwap) - using check on the previous UNIQUE value (prevValue)
PUT /v2/keys/trunk-location-service?prevValue=60b900c1-40c1-48f8-a122-b20cc6d24e79 HTTP/1.1  (application/x-www-form-urlencoded)
HTTP/1.1 200 OK  (application/json)
{"action":"compareAndSwap","node":{"key":"/trunk-location-service","value":"60b900c1-40c1-48f8-a122-b20cc6d24e79","expiration":"2022-04-23T11:22:04.457359084Z","ttl":2,"modifiedIndex":13823849,"createdIndex":13823834},"prevNode":{"key":"/trunk-location-service","value":"60b900c1-40c1-48f8-a122-b20cc6d24e79","expiration":"2022-04-23T11:22:03.945809839Z","ttl":2,"modifiedIndex":13823835,"createdIndex":13823834}}

--- First stops refreshing >> ETCD TTL times out -> watch index chagnes and value is null
1] GET /v2/keys/trunk-location-service?waitIndex=13824149 (X-Etcd-Index + 1)
Response body node.value IS NULL

Second starts leader election
PUT /v2/keys/trunk-location-service?prevExist=false HTTP/1.1  (application/x-www-form-urlencoded)
Now second won the election and becomes active
HTTP/1.1 201 Created  (application/json)










