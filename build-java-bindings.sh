#!/bin/bash

root=`pwd`
set -e

echo "##### Fetching sphinxbase..."
rm -rf sphinxbase
git clone --depth 1 https://github.com/mozilla/sphinxbase
rm -rf sphinxbase/.git

echo "##### Building sphinxbase..."
cd sphinxbase
./autogen.sh --without-python --with-pic --enable-static=yes --prefix=$root/target
make
make install
cd ..

echo "##### Building pocketsphinx..."
./autogen.sh --without-python --with-pic --enable-static=yes --with-sphinxbase=$root/sphinxbase --prefix=$root/target
make
make install

echo "##### Generating swig libraries..."
cd swig
make

echo "##### Generating jni module..."
cd java
make
cd ..

cd ..

echo "##### Packaging language models..."
cd model
for d in */; do 
    name="${d%/}"
    echo "Model: $name..."
    zip -r languagemodel-$name.zip $name
done
