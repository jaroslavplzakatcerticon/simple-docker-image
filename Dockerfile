
# https://hub.docker.com/_/tomcat

# https://github.com/docker-library/repo-info/blob/master/repos/tomcat/remote/10-jdk17-openjdk.md
FROM tomcat:10-jdk17-openjdk

COPY src/index.html /usr/local/tomcat/webapps/test/index.html

CMD ["catalina.sh", "run"]
