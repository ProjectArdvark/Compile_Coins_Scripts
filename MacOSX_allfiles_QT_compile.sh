#!/bin/sh
# Define Aardvark includes
source /usr/local/bin/Aardvark/core_system/aardvark_settings.config
updatedb
# Specify the path where you want to work
work_dir="$(pwd)"

# Continue with the rest of the script
cd depends
mkdir SDKs
cd SDKs
wget -c https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.15.sdk.tar.xz
tar -xf MacOSX10.15.sdk.tar.xz
cp /usr/local/bin/Aadvark/source_sdk/Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz .
tar -zxf Xcode-11.3.1-11C505-extracted-SDK-with-libcxx-headers.tar.gz
cd ..
make -j2 HOST=x86_64-apple-darwin11

./autogen.sh
mkdir "$(work_dir)"/db4
wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix="$(pwd)"/db4
make install

# Change directory to the specified path
cd "$work_dir" || { echo "Failed to change directory to $work_dir. Exiting."; exit 1; }

./autogen.sh
./configure --prefix=`pwd`/depends/x86_64-apple-darwin11
make -j2
make deploy
echo "No strip required for this file! DMG file is located in the same folder as this script."
