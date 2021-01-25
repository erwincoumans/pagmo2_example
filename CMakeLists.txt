cmake_minimum_required(VERSION 3.12)

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # For LLVM tooling
# set(CMAKE_BUILD_RPATH_USE_ORIGIN ON)

if (NOT EXISTS ${CMAKE_BINARY_DIR}/CMakeCache.txt)
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
  endif()
endif()


if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
	cmake_policy(SET CMP0017 NEW)
	cmake_policy(SET CMP0042 NEW)
	cmake_policy(SET CMP0057 NEW)
endif(COMMAND cmake_policy)
    
#this line has to appear before 'PROJECT' in order to be able to disable incremental linking
SET(MSVC_INCREMENTAL_DEFAULT ON)

PROJECT(pagmo2_example)

#IF(CMAKE_SYSTEM_NAME MATCHES "Linux")
#    link_libraries(stdc++fs)
#ENDIF()


find_package(Eigen3 QUIET REQUIRED)
if (Eigen3_FOUND)
    message("FOUND EIGEN")
    message("Eigen include directories: ${EIGEN3_INCLUDE_DIRS}")
    add_definitions(-DUSE_EIGEN)
else(Eigen3_FOUND)
    OPTION(USE_EIGEN_FALLBACK "Use third_party/eigen3" ON)
      if (USE_EIGEN_FALLBACK)
      message("Using third_party/eigen3")
      add_library (eigen INTERFACE)
      add_library (Eigen3::Eigen ALIAS eigen)
      #target_compile_definitions (eigen INTERFACE ${EIGEN_DEFINITIONS})
      target_include_directories (eigen INTERFACE
          ${CMAKE_CURRENT_LIST_DIR}/third_party/eigen3
      )
      set(Eigen3_FOUND TRUE)
      add_definitions(-DUSE_EIGEN)
    endif(USE_EIGEN_FALLBACK)
endif (Eigen3_FOUND)


find_package(Boost QUIET REQUIRED)
if (Boost_FOUND)
message("found boost!")
endif()

find_package(TBB REQUIRED)
IF(TBB_FOUND)
 message("TBB found")
ENDIF()

find_package(Pagmo CONFIG)
if (Pagmo_FOUND)
  message("FOUND PAGMO2!")
  message("${PAGMO_INCLUDE_DIRS}")
  add_definitions(-DUSE_PAGMO)
endif()

#show all cmake variables, for debugging
get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
   message(STATUS "${_variableName}=${${_variableName}}")
endforeach()

add_executable(pagmo2_example pagmo2_example.cpp )

target_link_libraries(pagmo2_example Eigen3::Eigen Pagmo::pagmo ${CMAKE_DL_LIBS})

#target_include_directories(pagmo2_example PRIVATE 
#  ../src 
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/boost_1_69_0
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/oneTBB/include
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/pagmo2/include
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/pagmo2/build_cmake/include
#  )
#target_link_directories (pagmo2_example  PRIVATE
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/boost_1_69_0/lib
#  ${CMAKE_CURRENT_LIST_DIR}/../third_party/oneTBB/build_cmake/local_install/lib
#  )
#
#target_link_directories (pagmo2_example PRIVATE ${CMAKE_CURRENT_LIST_DIR}/../third_party/pagmo2/build_cmake/lib )
#target_link_libraries (pagmo2_example  
#debug  pagmo 
#optimized pagmo_release)
