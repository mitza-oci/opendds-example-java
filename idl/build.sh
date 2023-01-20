#!/bin/sh

if [ "$DDS_ROOT" = "" ]; then
    echo ERROR: OpenDDS development environment, with DDS_ROOT, must be set
    exit 1
fi

rm -rf build
mkdir build
cd build
ln -sf ../Message.idl .
ln -sf ../Message.mpc .
$ACE_ROOT/bin/generate_export_file.pl Message > Message_Export.h
$ACE_ROOT/bin/mwc.pl -type gnuace
make -sj4

if [ `uname -s` = "Darwin" ]; then
    LIB_EXT=dylib
    LIB_EXT_VERSIONED=$LIB_EXT
else
    LIB_EXT=so
    LIB_EXT_VERSIONED="$LIB_EXT.*"
    SYMLINK_LIBS="OpenDDS_Rtps_Udp OpenDDS_DCPS_Java"
fi

mkdir libs
cd libs
cp ../*.jar .
cp ../*.$LIB_EXT .
cp $DDS_ROOT/lib/*.jar .

OPENDDS_LIBS="OpenDDS_DCPS_Java idl2jni_runtime OpenDDS_Dcps OpenDDS_Rtps OpenDDS_Rtps_Udp"
ACE_LIBS="TAO_Valuetype TAO_AnyTypeCode TAO ACE"

for libname in $OPENDDS_LIBS; do
    cp $DDS_ROOT/lib/lib$libname.$LIB_EXT_VERSIONED .
done
for libname in $ACE_LIBS; do
    cp $ACE_ROOT/lib/lib$libname.$LIB_EXT_VERSIONED .
done
for libname in $SYMLINK_LIBS; do
    # non-versioned link to support dlopen
    ln -sf lib$libname.so.* lib$libname.so
done
