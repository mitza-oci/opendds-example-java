#!/bin/sh

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:../../idl/build/libs
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:../../idl/build/libs

if [ "$JAVA_HOME" != "" ]; then
    PREFIX=${JAVA_HOME}/bin/
fi

cd build
${PREFIX}java -cp ".:../../idl/build/libs/*" ExamplePublisher "$@" -DCPSConfigFile ../../rtps.ini
