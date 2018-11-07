git clone git@github.com:jonls/qsopt-ex.git
cd qsopt-ex
./bootstrap
mkdir build
cd build
../configure
make install
cd ../../
ln -s ./qsopt-ex/build/esolver/.libs/esolver qsopt-ex.run