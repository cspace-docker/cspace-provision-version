#
# cspace-version Dockerfile
#
# Dockerfile 2 of 3 to install and configure a CollectionSpace
# server instance inside a Docker container.
#
# This Dockerfile is specific to and requires Ubuntu Linux,
# although most of its instructions should likely work with
# any recent Debian-based Linux distribution.
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
ENV APACHE_TOMCAT_PARENT_DIR /usr/local/share
ENV CSPACE_SERVER_FILENAME cspace-server
ENV TARBALL_EXTENSION .tar.gz
ENV CATALINA_HOME $APACHE_TOMCAT_PARENT_DIR/$APACHE_TOMCAT_NAME
ENV CATALINA_PID $CATALINA_HOME/bin/tomcat.pid
ENV CATALINA_OPTS -Xmx1024m -XX:MaxPermSize=384m
ENV CSPACE_JEESERVER_HOME $CATALINA_HOME

#
# Add these additional environment variables to the
# /etc/environment system file, so that they will be
# made available to all system users.
#
# (The $SCRIPT_INSTALL_DIR is defined in the cspace-base
# image's Dockerfile.)
#
RUN $SCRIPT_INSTALL_DIR/add-env-vars.sh CATALINA_HOME_PARENT CATALINA_HOME CATALINA_PID CATALINA_OPTS CSPACE_JEESERVER_HOME

#
# Set CollectionSpace's version information.
#
# FIXME: For production, replace the following temporary value,
# used during 4.1-beta1 testing, with the ENV command directly
# below this one:
#
ENV COLLECTIONSPACE_VERSION 4.1-beta1
# ENV COLLECTIONSPACE_GIT_BRANCH v$COLLECTIONSPACE_VERSION
ENV COLLECTIONSPACE_GIT_BRANCH master
ENV COLLECTIONSPACE_TARBALL $CSPACE_SERVER_FILENAME-$COLLECTIONSPACE_VERSION$TARBALL_EXTENSION

#
# Download and install the CollectionSpace distribution package
# for the version specified in the environment variable
# $COLLECTIONSPACE_VERSION.
#
ADD wget-cspace-distro.sh $SCRIPT_INSTALL_DIR/wget-cspace-distro.sh
RUN chmod ug+x $SCRIPT_INSTALL_DIR/wget-cspace-distro.sh
RUN $SCRIPT_INSTALL_DIR/wget-cspace-distro.sh

#
# Set up a service script for starting, stopping, and restarting
# CollectionSpace, with default run levels.
#
ADD tomcat.sh /etc/init.d/tomcat
RUN chmod 755 /etc/init.d/tomcat
RUN update-rc.d tomcat defaults

#
# Check out the CollectionSpace source code, for the version
# specified in the environment variable $COLLECTIONSPACE_VERSION.
#
ADD update-cspace-src.sh $SCRIPT_INSTALL_DIR/update-cspace-src.sh
RUN chmod ug+x $SCRIPT_INSTALL_DIR/update-cspace-src.sh
RUN $SCRIPT_INSTALL_DIR/update-cspace-src.sh

#
# Perform a full source code build and deployment,
# from the top layer-down.
#

#
# Build the User Interface (UI) layer
#
RUN cd $USER_HOME/$CSPACE_USERNAME/src/ui && mvn clean install -DskipTests

# Build the Application layer
# NOTE: We must build the Application layer before the Services layer
# since it creates the configuration tool needed to create the Service
# layer's configuration artifacts; i.e items such as the Nuxeo plugins
# and service bindings.
#
RUN cd $USER_HOME/$CSPACE_USERNAME/src/application && mvn clean install -DskipTests

#
# Set environment variables needed by the Services layer.
#
# The following values are placeholders; they will be replaced by
# instance-specific values in the third layer's Dockerfile:
#
ENV DB_CSADMIN_PASSWORD placeholderpassword
ENV DB_CSPACE_PASSWORD placeholderpassword
ENV DB_NUXEO_PASSWORD placeholderpassword
ENV DB_READER_PASSWORD placeholderpassword
ENV DB_HOST localhost
ENV DB_PORT 5432
ENV CSPACE_INSTANCE_ID _placeholderid

#
# Build the Services layer
#
RUN cd $USER_HOME/$CSPACE_USERNAME/src/services && mvn clean install -DskipTests






