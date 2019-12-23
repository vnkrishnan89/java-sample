FROM tomcat:8.5
COPY target/webappRunnerSample.war /usr/local/tomcat/webapps/webappRunnerSample.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
