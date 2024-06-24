#!/bin/bash
clear

PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')

# Define Aardvark includes
source /usr/local/bin/Aardvark/core_system/aardvark_settings.config

# Specify the path where you want to work
work_dir="$(pwd)"

# Continue with the rest of the script
cd depends
make -j2 HOST=x86_64-w64-mingw32 
cd ..

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
./configure --disable-online-rust LDFLAGS="-L`pwd`/db4/lib/" CPPFLAGS="-I`pwd`/db4/include/" --prefix=`pwd`/depends/x86_64-w64-mingw32
make -j2

echo "Remember to strip the QT file!"

# Another example log message
log_message "Script finished."