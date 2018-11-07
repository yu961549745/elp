tar -xvzf soplex-4.0.0.tgz
mv soplex-4.0.0 soplex 
cd soplex
mkdir build
cd build
cmake ..
make