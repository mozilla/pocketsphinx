#!/bin/bash

echo "##### Installing swig..."
if [[ `uname` == 'Darwin' ]]; then
    brew update
    brew install swig
    export JAVA_HOME=`/usr/libexec/java_home`
else
    sudo apt-get install -y swig
fi
