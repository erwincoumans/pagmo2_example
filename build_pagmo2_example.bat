@set ROOT=%cd%
@echo root= %ROOT%


git submodule update --init --recursive

pushd third_party\eigen
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_DEBUG_POSTFIX="" -DINSTALL_LIBS=ON -DCMAKE_BUILD_TYPE=Release  -DCMAKE_INSTALL_PREFIX:PATH=local_install  ..
cmake  --build .  --target INSTALL  --config Debug
cmake  --build .  --target INSTALL  --config Release
popd
cd %ROOT%

pushd third_party\boost
call bootstrap.bat
b2 --with-serialization
popd
cd %ROOT%


pushd third_party\oneTBB
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DTBB_TEST=OFF -DBUILD_SHARED_LIBS=OFF ..
cmake  --build .  --target INSTALL  --config Debug
cmake  --build .  --target INSTALL  --config Release
popd
cd %ROOT%


pushd third_party\pagmo2
git apply ..\pagmo2_msvc.diff
mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DPAGMO_WITH_EIGEN3=ON -DBoost_DIR:PATH=%ROOT%/third_party/boost/stage/lib/cmake/Boost-1.75.0 -DEigen3_DIR:PATH=%ROOT%/third_party/eigen/build_cmake -DTBB_VERSION=2021.1.0 -DPAGMO_BUILD_STATIC_LIBRARY=ON -DTBB_ROOT=%ROOT%/third_party/oneTBB/build_cmake/local_install ..
cmake  --build .  --target INSTALL  --config Debug
cmake  --build .  --target INSTALL  --config Release
popd
cd %ROOT%


mkdir build_cmake
cd build_cmake
cmake -DCMAKE_INSTALL_PREFIX:PATH=local_install -DPAGMO_WITH_EIGEN3=ON -DBoost_DIR:PATH=%ROOT%/third_party/boost/stage/lib/cmake/Boost-1.75.0 -DEigen3_DIR:PATH=%ROOT%/third_party/eigen/build_cmake -DTBB_VERSION=2021.1.0 -DPagmo_DIR:PATH=%ROOT%/third_party/pagmo2/build_cmake/local_install/lib/cmake/pagmo -DTBB_ROOT=%ROOT%/third_party/oneTBB/build_cmake/local_install ..
cmake  --build .  --target ALL_BUILD    --config Release

