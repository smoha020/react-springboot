#!/bin/bash

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"
#MVNURL="https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz"

apt update -y && apt install -y openjdk-8-jdk maven git wget -y


#INSTALL TOMCAT
cd /tmp/
wget $TOMURL -O tomcatbin.tar.gz
EXTOUT=`tar xzvf tomcatbin.tar.gz`
TOMDIR=`echo $EXTOUT | cut -d '/' -f1`
useradd --shell /sbin/nologin tomcat
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat8/
chown -R tomcat.tomcat /usr/local/tomcat8

rm -rf /etc/systemd/system/tomcat.service

cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

ExecReload=/bin/kill $MAINPID
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

#CLONE THE REPO
cd ~
git clone https://github.com/smoha020/react-springboot.git
cd react-springboot/api

#BUILD THE ARTIFACT
mvn install
systemctl stop tomcat
sleep 60

#DEPLOY THE WAR FILE TO TOMCAT
rm -rf /usr/local/tomcat8/webapps/ROOT*
cp target/bookworld.war /usr/local/tomcat8/webapps/ROOT.war
#cp /home/ec2-user/bookworld.war /usr/local/tomcat8/webapps/ROOT.war
systemctl start tomcat
sleep 120
#cp /vagrant/application.properties /usr/local/tomcat8/webapps/ROOT/WEB-INF/classes/application.properties
systemctl restart tomcat
