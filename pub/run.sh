#!/bin/sh

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:../idl/build/libs
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:../idl/build/libs

if [ "$JAVA_HOME" != "" ]; then
    PREFIX=${JAVA_HOME}/bin/
fi

${PREFIX}java -cp "build:../idl/build/libs/*" ExamplePublisher "$@" -DCPSConfigFile ../rtps.ini
