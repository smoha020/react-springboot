FROM tomcat

RUN mv webapps webapps2 \
    && mv webapps.dist/ webapps
RUN rm -rf /usr/local/tomcat/webapps/ROOT*
COPY target/bookworld.war /usr/local/tomcat/webapps/ROOT.war
RUN sleep 120
#COPY src/main/resources/application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
# COPY target/bookworld.war /usr/local/tomcat/webapps/


#------JAR FILE 
# FROM openjdk:8
# ADD target/bookworld.jar bookworld.jar
# COPY /src /src
# ENTRYPOINT ["java", "-jar", "bookworld"]
