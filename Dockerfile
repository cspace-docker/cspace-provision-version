FROM rem/cspace-base
MAINTAINER Richard Millet "richard.millet@berkeley.edu"

#
# Setup CollectionSpace's Apache Tomcat environment
#
ENV APACHE_TOMCAT_NAME apache-tomcat-6.0.33
ENV CATALINA_HOME_PARENT /usr/local/share
ENV CATALINA_HOME $CATALINA_HOME_PARENT/$APACHE_TOMCAT_NAME
ENV CATALINA_PID $CATALINA_HOME/bin/tomcat.pid
ENV CATALINA_OPTS -Xmx1024m -XX:MaxPermSize=384m
ENV CSPACE_JEESERVER_HOME $CATALINA_HOME

#
# Add the environment variables to the /etc/environment system file
#
RUN ./add-env-vars.sh CATALINA_HOME_PARENT CATALINA_HOME CATALINA_PID CATALINA_OPTS CSPACE_JEESERVER_HOME

#
# Set CollectionSpace version information
#
ENV COLLECTIONSPACE_VERSION 3.3
ENV COLLECTIONSPACE_GIT_BRANCH v$COLLECTIONSPACE_VERSION
ENV COLLECTIONSPACE_TARBALL $APACHE_TOMCAT_NAME-2013-07-09.tar.gz

#
# Download and install the CollectionSpace distribution package for the version specified in the environment variable $COLLECTIONSPACE_VERSION
#
ADD wget-cspace-distro.sh wget-cspace-distro.sh
RUN chmod ug+x wget-cspace-distro.sh
RUN ./wget-cspace-distro.sh

#
# Get the latest version of the CollectionSpace source for the version specified in the environment variable $COLLECTIONSPACE_VERSION
#
ADD update-cspace-src.sh update-cspace-src.sh
RUN chmod ug+x update-cspace-src.sh
RUN ./update-cspace-src.sh
