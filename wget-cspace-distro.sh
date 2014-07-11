#!/usr/bin/env bash

#
# Download and install the CollectionSpace distribution package, for the version
# specified in the environment variable $COLLECTIONSPACE_VERSION.
#
wget -q ftp://source.collectionspace.org/pub/collectionspace/releases/$COLLECTIONSPACE_VERSION/$COLLECTIONSPACE_TARBALL
tar zxvof $COLLECTIONSPACE_TARBALL
mv $COLLECTIONSPACE_TARBALL $APACHE_TOMCAT_PARENT_DIR
mv $APACHE_TOMCAT_NAME $APACHE_TOMCAT_PARENT_DIR
chmod u+x $APACHE_TOMCAT_PARENT_DIR/$APACHE_TOMCAT_NAME/bin/*.sh
chown -R $CSPACE_USERNAME:$CSPACE_USERNAME $APACHE_TOMCAT_PARENT_DIR/$APACHE_TOMCAT_NAME

exit 0
