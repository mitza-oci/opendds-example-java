@echo off
setlocal
rmdir /s/q build 2>NUL
mkdir build
cd build
copy ..\Message.idl
copy ..\Message.mpc
perl %ACE_ROOT%\bin\generate_export_file.pl Message > Message_Export.h
perl %ACE_ROOT%\bin\mwc.pl -type vs2022
msbuild -p:Configuration=Debug,Platform=x64 -m build.sln
