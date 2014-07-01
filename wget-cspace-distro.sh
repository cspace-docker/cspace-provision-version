#!/usr/bin/env bash

#
# Download and install the CollectionSpace distribution package, for the version
# specified in the environment variable $COLLECTIONSPACE_VERSION.
#
wget -q ftp://source.collectionspace.org/pub/collectionspace/releases/$COLLECTIONSPACE_VERSION/$COLLECTIONSPACE_TARBALL
tar zxvof $COLLECTIONSPACE_TARBALL
chmod u+x $APACHE_TOMCAT_NAME/bin/*.sh
mv $COLLECTIONSPACE_TARBALL /usr/local/share
mv $APACHE_TOMCAT_NAME /usr/local/share

exit 0
