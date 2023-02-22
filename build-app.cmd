@echo off
setlocal

rmdir /s/q build 2>NUL
mkdir build

if defined JAVA_HOME set PREFIX=%JAVA_HOME%\bin\

"%PREFIX%javac" -cp ../idl/libs/* -d build *.java
