#!/bin/bash

echo "##### Installing swig..."
if [[ `uname` == 'Darwin' ]]; then
    brew update
    brew install swig
else
    sudo apt-get install -y swig
fi
