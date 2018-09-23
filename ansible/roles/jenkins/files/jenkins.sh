#!/bin/bash

# chkconfig: 345 99 01
# description: some startup script

case $1 in 
    start)
        export JENKINS_HOME=/var/lib/jenkins
        export JENKINS_USER=jenkins
        export JENKINS_LOG=/var/log/builds.orbis.pe.log
        export JENKINS_JAVA=/usr/bin/java
        export JENKINS_IP=127.0.0.1
        export JENKINS_PORT=8090
        export JENKINS_JAVA_OPTIONS="-Duser.timezone=America/Lima"

        echo "" > /var/log/builds.orbis.pe.log
        chown jenkins:jenkins /var/log/builds.orbis.pe.log
        su jenkins -c "/usr/bin/java -Djenkins.install.runSetupWizard=false -jar /var/lib/jenkins/jenkins.war -Duser.timezone=America/Lima --httpListenAddress=127.0.0.1 --httpPort=8090 --logfile=/var/log/builds.orbis.pe.log &"
        sleep 15s
        sh /tmp/installer.sh
        sed -i '/installer/d' /etc/init.d/jenkins
        ;;
    stop)
        killall -9 java
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        exit 1
        ;;
esac
exit 0
