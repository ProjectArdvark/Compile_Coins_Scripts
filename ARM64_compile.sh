#!/bin/sh
make clean
chmod 777 -R *
cd `pwd`/depends
make -j2 HOST=aarch64-linux-gnu
cd ..
./autogen.sh
mkdir `pwd`/db4
wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd `pwd`/db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=`pwd`/db4
make install
cd ../../
./autogen.sh
./configure --disable-online-rust LDFLAGS="-L`pwd`/db4/lib/" CPPFLAGS="-I`pwd`/db4/include/" --prefix=`pwd`/depends/aarch64-linux-gnu --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
make -j2
echo "Remember to strip the daemon, cli, and tx files!"
