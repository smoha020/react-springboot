#!/bin/bash

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"
MVNURL="https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz"

yum install java-1.8.0-openjdk -y
yum install git wget -y

#INSTALL NEWER VERSION MAVEN (AMAZON LINUX MAVEN IS OUTDATED)
#yum install maven   #THIS WILL GIVE YOU AN OUTDATED VERSION THAT CAN'T BUILD YOUR PROJECT

cd /opt/
wget $MVNURL -O maven.tar.gz
MVNTAR=`tar xzvf maven.tar.gz`
MVNDIR=`echo $MVNTAR | cut -d '/' -f 1`
ln -s /opt/$MVNDIR /opt/maven
cat << EOF > /etc/profile.d/maven.sh
#!/bin/sh
export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:$PATH
EOF
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh



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
Description=Tomcat
After=network.target
[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat8
#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
RestartSec=10
Restart=always
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
