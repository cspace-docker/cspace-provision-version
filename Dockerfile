FROM cspace-base
MAINTAINER Richard Millet "richard.millet@berkeley.edu"

#
# Setup additional Apache Tomcat variables
#
ENV APACHE_TOMCAT_NAME apache-tomcat-6.0.33
ENV CATALINA_HOME $CATALINA_HOME_PARENT/$APACHE_TOMCAT_NAME

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
RUN cd $HOME/$CSPACE_USERNAME/src/services && git checkout && git pull
RUN cd $HOME/$CSPACE_USERNAME/src/application && git checkout && git pull
RUN cd $HOME/$CSPACE_USERNAME/src/ui && git checkout && git pull
