##!/bin/sh
ROOT=$(pwd)
echo $ROOT

git submodule update --init --recursive

pushd third_party/eigen
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_DEBUG_POSTFIX="" -DINSTALL_LIBS=ON -DCMAKE_BUILD_TYPE=Release  -DCMAKE_INSTALL_PREFIX:PATH=local_install  ..
make -j4
make install
popd
cd $ROOT

pushd third_party/boost
./bootstrap.sh
./b2 --with-serialization
popd
cd $ROOT


pushd third_party/oneTBB
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DTBB_TEST=OFF -DBUILD_SHARED_LIBS=ON ..
make -j4
make install
popd
cd $ROOT


pushd third_party/pagmo2
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DPAGMO_WITH_EIGEN3=ON -DBoost_DIR:PATH=$ROOT/third_party/boost/stage/lib/cmake/Boost-1.75.0 -DEigen3_DIR:PATH=$ROOT/third_party/eigen/build_cmake -DTBB_VERSION=2021.1.0 -DPAGMO_BUILD_STATIC_LIBRARY=OFF -DTBB_ROOT=$ROOT/third_party/oneTBB/build_cmake/local_install ..

make -j4
make install
popd
cd $ROOT


mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DPAGMO_WITH_EIGEN3=ON -DBoost_DIR:PATH=$ROOT/third_party/boost/stage/lib/cmake/Boost-1.75.0 -DEigen3_DIR:PATH=$ROOT/third_party/eigen/build_cmake -DTBB_VERSION=2021.1.0 -DPagmo_DIR:PATH=$ROOT/third_party/pagmo2/build_cmake/local_install/lib/cmake/pagmo -DTBB_ROOT=$ROOT/third_party/oneTBB/build_cmake/local_install ..

make

