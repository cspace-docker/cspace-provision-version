#!/bin/bash

cd $USER_HOME/$CSPACE_USERNAME/src/services && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull
cd $USER_HOME/$CSPACE_USERNAME/src/application && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull
cd $USER_HOME/$CSPACE_USERNAME/src/ui && git checkout $COLLECTIONSPACE_GIT_BRANCH && git pull

exit 0