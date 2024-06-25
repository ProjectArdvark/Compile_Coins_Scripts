#!/bin/bash
# Define Aardvark includes

updatedb
chmod -R 775 *
cd `pwd`/depends
sudo mkdir SDKs
cd SDKs
wget -c https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.15.sdk.tar.xz
tar -xf MacOSX10.15.sdk.tar.xz

cp /usr/local/bin/Aardvark/source_sdk/Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz . 
tar -zxf Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz
cd ..
chmod -R 775 *
updatedb
make -j2 HOST=x86_64-apple-darwin11
cd ..
./autogen.sh
mkdir db4
wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd `pwd`/db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix="$(pwd)"/db4
chmod -R 775 *
make install
cd ../../
./autogen.sh
./configure --prefix=`pwd`/depends/x86_64-apple-darwin11
updatedb
chmod -R 775 *
make -j2
updatedb
make deploy
echo "No strip required for this file! DMG file is located in the same folder as this script."
