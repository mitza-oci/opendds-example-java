@echo off
setlocal
set CONFIGURATION=Debug
rmdir /s/q build 2>NUL
mkdir build
cd build
xcopy /q ..\Message.idl
xcopy /q ..\Message.mpc
perl %ACE_ROOT%\bin\generate_export_file.pl Message > Message_Export.h
perl %ACE_ROOT%\bin\mwc.pl -type vs2022
msbuild -p:Configuration=%CONFIGURATION%,Platform=x64 -m build.sln
mkdir libs
xcopy /q *.jar libs
xcopy /q *.dll libs

set OPENDDS_LIBS=OpenDDS_DCPS_Java idl2jni_runtime OpenDDS_Dcps OpenDDS_Rtps OpenDDS_Rtps_Udp
set ACE_LIBS=TAO_Valuetype TAO_AnyTypeCode TAO ACE

if %CONFIGURATION%==Debug set SUFFIX=d

xcopy /q %DDS_ROOT%\lib\*.jar libs
for %%f in (%OPENDDS_LIBS%) do @xcopy /q %DDS_ROOT%\lib\%%f%SUFFIX%.dll libs
for %%f in (%ACE_LIBS%) do @xcopy /q %ACE_ROOT%\lib\%%f%SUFFIX%.dll libs
