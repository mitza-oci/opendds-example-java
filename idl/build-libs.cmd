@echo off
setlocal
rmdir /s/q build 2>NUL
mkdir build
cd build
xcopy /q ..\Message.idl
xcopy /q ..\Message.mpc
perl %ACE_ROOT%\bin\mwc.pl -type vs2022
msbuild -p:Configuration=%CONFIGURATION%,Platform=x64 -m build.sln
cd ..
rmdir /s/q libs 2>NUL
mkdir libs
xcopy /q build\*.jar libs
xcopy /q build\*.dll libs

if %CONFIGURATION%==Debug set SUFFIX=d

set OPENDDS_LIBS=OpenDDS_DCPS_Java idl2jni_runtime OpenDDS_Dcps OpenDDS_Rtps OpenDDS_Rtps_Udp OpenDDS_Tcp OpenDDS_Udp OpenDDS_Multicast OpenDDS_Security
set ACE_LIBS=TAO_Valuetype TAO_AnyTypeCode TAO ACE_XML_Utils ACE
set EXT_LIBS=libcrypto-3-x64.dll xerces-c_3_2%SUFFIX%.dll

xcopy /q %DDS_ROOT%\lib\*.jar libs
for %%f in (%OPENDDS_LIBS%) do @xcopy /q %DDS_ROOT%\lib\%%f%SUFFIX%.dll libs
for %%f in (%ACE_LIBS%) do @xcopy /q %ACE_ROOT%\lib\%%f%SUFFIX%.dll libs
for %%f in (%EXT_LIBS%) do @xcopy /q %%~dp$PATH:f%%f libs
