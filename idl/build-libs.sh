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
$ACE_ROOT/bin/mwc.pl -type gnuace
make -sj4

if [ `uname -s` = "Darwin" ]; then
    LIB_EXT=dylib
    LIB_EXT_VERSIONED=$LIB_EXT
else
    LIB_EXT=so
    LIB_EXT_VERSIONED="$LIB_EXT.*"
    SYMLINK_LIBS="OpenDDS_Rtps_Udp OpenDDS_Security OpenDDS_DCPS_Java idl2jni_runtime"
fi

cd ..
rm -rf libs
mkdir libs
cd libs
cp ../build/*.jar .
cp ../build/*.$LIB_EXT .
cp $DDS_ROOT/lib/*.jar .

OPENDDS_LIBS="OpenDDS_DCPS_Java idl2jni_runtime OpenDDS_Dcps OpenDDS_Rtps OpenDDS_Rtps_Udp OpenDDS_Tcp OpenDDS_Udp OpenDDS_Multicast OpenDDS_Security"
ACE_LIBS="TAO_Valuetype TAO_AnyTypeCode TAO ACE_XML_Utils ACE"

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
if [ $SSL_ROOT != /usr ]; then
    cp $SSL_ROOT/lib/lib{ssl,crypto}.*.$LIB_EXT* .
fi
if [ $XERCESCROOT != /usr ]; then
    cp $XERCESCROOT/lib/libxerces-c-*.$LIB_EXT .
fi
