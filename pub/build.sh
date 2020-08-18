#!/bin/sh

rm -rf build
mkdir build
javac -cp "../idl/build/libs/*" -d build ExamplePublisher.java
