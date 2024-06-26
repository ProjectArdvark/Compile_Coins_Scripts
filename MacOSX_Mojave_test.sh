#!/bin/sh
sudo make clean
sudo apt-get update
sudo apt-get -y upgrade
sudo chmod -Rv 775
cd `pwd`/depends
sudo mkdir SDKs
cd SDKs
sudo wget -c https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.15.sdk.tar.xz
sudo tar -xf MacOSX10.15.sdk.tar.xz
sudo wget https://media.spectresecurity.io/files/Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz
sudo tar -xf Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz
cd ..
sudo make -j2 HOST=x86_64-apple-darwin14
cd ..
sudo ./autogen.sh
sudo mkdir db4
sudo wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
sudo tar -xzvf db-4.8.30.NC.tar.gz
cd `pwd`/db-4.8.30.NC/build_unix/
sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=`pwd`/db4
sudo make install
cd ../../
sudo chmod -Rv 775
sudo ./autogen.sh
sudo ./configure --disable-online-rust --prefix=`pwd`/depends/x86_64-apple-darwin14
sudo make -j2
sudo make deploy
echo "No strip required for this file! DMG file is located in the same folder as this script."
