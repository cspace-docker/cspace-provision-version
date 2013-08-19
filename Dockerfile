FROM rem/cspace-base
MAINTAINER Richard Millet "richard.millet@berkeley.edu"

#
# Setup CollectionSpace's Apache Tomcat environment
#
ENV APACHE_TOMCAT_NAME apache-tomcat-6.0.33
ENV CATALINA_HOME_PARENT /usr/local/share
RUN echo CATALINA_HOME_PARENT=$CATALINA_HOME_PARENT >> /etc/environment

ENV CATALINA_HOME $CATALINA_HOME_PARENT/$APACHE_TOMCAT_NAME
RUN echo CATALINA_HOME=$CATALINA_HOME >> /etc/environment

ENV CATALINA_PID $CATALINA_HOME/bin/tomcat.pid
RUN echo CATALINA_PID=$CATALINA_PID >> /etc/environment

ENV CATALINA_OPTS -Xmx1024m -XX:MaxPermSize=384m
RUN echo CATALINA_OPTS=$CATALINA_OPTS >> /etc/environment

ENV CSPACE_JEESERVER_HOME $CATALINA_HOME
RUN echo CSPACE_JEESERVER_HOME=$CSPACE_JEESERVER_HOME >> /etc/environment

#
# Set CollectionSpace version information
#
ENV COLLECTIONSPACE_VERSION 3.3
ENV COLLECTIONSPACE_GIT_BRANCH v$COLLECTIONSPACE_VERSION
ENV COLLECTIONSPACE_TARBALL $APACHE_TOMCAT_NAME-2013-07-09.tar.gz

#
# Download and install the CollectionSpace distribution package for the version specified in the environment variable $COLLECTIONSPACE_VERSION
#
ENV CSPACE_JEESERVER_HOME $CATALINA_HOME
RUN wget -q ftp://source.collectionspace.org/pub/collectionspace/releases/$COLLECTIONSPACE_VERSION/$COLLECTIONSPACE_TARBALL
RUN tar zxvof $COLLECTIONSPACE_TARBALL
RUN chmod u+x $APACHE_TOMCAT_NAME/bin/*.sh
RUN mv $COLLECTIONSPACE_TARBALL /usr/local/share
RUN mv $APACHE_TOMCAT_NAME /usr/local/share

#
# Get the latest version of the CollectionSpace source for the version specified in the environment variable $COLLECTIONSPACE_VERSION
#
RUN cd $HOME/$CSPACE_USERNAME/src/services && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull
RUN cd $HOME/$CSPACE_USERNAME/src/application && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull
RUN cd $HOME/$CSPACE_USERNAME/src/ui && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull
