#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
    export JAVA_HOME=`/usr/libexec/java_home`
fi

./build-java-bindings.sh
