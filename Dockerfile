#
# cspace-version Dockerfile
#
# Dockerfile 2 of 3 to install and configure a CollectionSpace
# server instance inside a Docker container.
#

#
# Start from the Docker image built by running the
# 'cspace-base' Dockerfile.
#
FROM collectionspace/cspace-base
MAINTAINER Richard Millet "richard.millet@berkeley.edu"

#
# Declare environment variables to set up CollectionSpace's
# Apache Tomcat environment.
#
ENV APACHE_TOMCAT_NAME apache-tomcat-6.0.33
ENV CSPACE_SERVER_FILENAME cspace-server
ENV TARBALL_EXTENSION .tar.gz
ENV CATALINA_HOME_PARENT /usr/local/share
ENV CATALINA_HOME $CATALINA_HOME_PARENT/$APACHE_TOMCAT_NAME
ENV CATALINA_PID $CATALINA_HOME/bin/tomcat.pid
ENV CATALINA_OPTS -Xmx1024m -XX:MaxPermSize=384m
ENV CSPACE_JEESERVER_HOME $CATALINA_HOME

#
# Add these additional environment variables to the
# /etc/environment system file, so that they will be
# made available to all system users.
#
RUN ./add-env-vars.sh CATALINA_HOME_PARENT CATALINA_HOME CATALINA_PID CATALINA_OPTS CSPACE_JEESERVER_HOME

#
# Set CollectionSpace's version information.
#
# FIXME: Replace the following temporary value, used during 4.1-beta1 testing,
# with the ENV command directly below:
#
ENV COLLECTIONSPACE_VERSION 4.1-beta1
# ENV COLLECTIONSPACE_GIT_BRANCH v$COLLECTIONSPACE_VERSION
ENV COLLECTIONSPACE_GIT_BRANCH master
ENV COLLECTIONSPACE_TARBALL $CSPACE_SERVER_FILENAME-$COLLECTIONSPACE_VERSION$TARBALL_EXTENSION

#
# Download and install the CollectionSpace distribution package for the version
# specified in the environment variable $COLLECTIONSPACE_VERSION.
#
ADD wget-cspace-distro.sh wget-cspace-distro.sh
RUN chmod ug+x wget-cspace-distro.sh
RUN ./wget-cspace-distro.sh

#
# Check out the CollectionSpace source code, for the version
# specified in the environment variable $COLLECTIONSPACE_VERSION.
#
ADD update-cspace-src.sh update-cspace-src.sh
RUN chmod ug+x update-cspace-src.sh
RUN ./update-cspace-src.sh



