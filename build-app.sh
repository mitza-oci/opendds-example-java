#!/bin/sh

rm -rf build
mkdir build

if [ "$JAVA_HOME" != "" ]; then
    PREFIX=${JAVA_HOME}/bin/
fi

${PREFIX}javac -cp "../idl/build/libs/*" -d build *.java
