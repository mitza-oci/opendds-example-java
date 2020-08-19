#!/bin/sh

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:../../idl/build/libs
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:../../idl/build/libs

cd build
java -cp ".:../../idl/build/libs/*" ExampleSubscriber "$@" -DCPSConfigFile ../../rtps.ini
