@echo off
setlocal
set PATH=%PATH%;..\idl\build\libs
if defined JAVA_HOME set PREFIX=%JAVA_HOME%\bin\
if %CONFIGURATION%==Debug set PROPS=-Dopendds.native.debug=true

"%PREFIX%java" -cp build;..\idl\build\libs\* %PROPS% ExampleSubscriber %* -DCPSConfigFile ..\rtps.ini
