tar xzf soplex-4.0.0.tgz 
mv soplex-4.0.0 soplex
cd soplex 
mkdir build
sed -i 's/mpir_version/__MPIR_VERSION/g' src/soplex.cpp
cp ../win-build.bat build