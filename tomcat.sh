#!/usr/bin/env sh

# See http://wiki.openkm.com/index.php/Configure_Tomcat_service_linux
 
### BEGIN INIT INFO
# Provides:          tomcat
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop Apache Tomcat
# Description:       Enable Apache Tomcat service provided by daemon.
### END INIT INFO
 
ECHO=/bin/echo
TEST=/usr/bin/test
TOMCAT_USER=cspace
TOMCAT_HOME=/usr/local/share/apache-tomcat-6.0.33
TOMCAT_START_SCRIPT=$TOMCAT_HOME/bin/startup.sh
TOMCAT_FOREGROUND_START_SCRIPT=$TOMCAT_HOME/bin/catalina.sh
TOMCAT_STOP_SCRIPT=$TOMCAT_HOME/bin/shutdown.sh
 
$TEST -x $TOMCAT_START_SCRIPT || exit 0
$TEST -x $TOMCAT_FOREGROUND_START_SCRIPT || exit 0
$TEST -x $TOMCAT_STOP_SCRIPT || exit 0
 
start() {
    $ECHO -n "Starting Tomcat"
    su - $TOMCAT_USER -c "$TOMCAT_START_SCRIPT &"
    $ECHO "."
}

startforeground() {
    $ECHO -n "Starting Tomcat in foreground"
    su - $TOMCAT_USER -c "$TOMCAT_FOREGROUND_START_SCRIPT run"
    $ECHO "."
}
 
stop() {
    $ECHO -n "Stopping Tomcat"
    su - $TOMCAT_USER -c "$TOMCAT_STOP_SCRIPT 60 -force &"
    while [ "$(ps -fu $TOMCAT_USER | grep java | grep tomcat | wc -l)" -gt "0" ]; do
        sleep 5; $ECHO -n "."
    done
    $ECHO "."
}
 
case "$1" in
    start)
        start
        ;;
    startforeground)
        startforeground
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 30
        start
        ;;
    *)
        $ECHO "Usage: tomcat {start|startforeground|stop|restart}"
        exit 1
esac
exit 0