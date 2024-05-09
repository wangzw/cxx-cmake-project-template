cmake_minimum_required(VERSION 3.27)

if (POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif ()

project(thirdparty)

include(ExternalProject)

# Required for unit test
ExternalProject_Add(googletest
        PREFIX googletest
        URL "https://github.com/google/googletest/archive/refs/tags/v1.14.0.tar.gz"
        URL_HASH "MD5=c8340a482851ef6a3fe618a082304cfc"
        DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/googletest/src/googletest-1.14.0"
        CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH:LIST=${CMAKE_PREFIX_PATH}
        -DCMAKE_FIND_ROOT_PATH:LIST=${CMAKE_FIND_ROOT_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
)

# Required for benchmark test
ExternalProject_Add(benchmark
        PREFIX benchmark
        GIT_REPOSITORY "https://github.com/google/benchmark.git"
        GIT_TAG "v1.8.3"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/benchmark/src/benchmark"
        CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH:LIST=${CMAKE_PREFIX_PATH}
        -DCMAKE_FIND_ROOT_PATH:LIST=${CMAKE_FIND_ROOT_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DBENCHMARK_ENABLE_TESTING:BOOL=OFF
        -DBENCHMARK_ENABLE_WERROR:BOOL=OFF
        -DBENCHMARK_INSTALL_DOCS:BOOL=OFF
        -DBENCHMARK_ENABLE_GTEST_TESTS:BOOL=OFF
)

# Required for generating documents.
ExternalProject_Add(doxygen
        PREFIX doxygen
        URL "https://github.com/doxygen/doxygen/archive/refs/tags/Release_1_10_0.tar.gz"
        URL_HASH "MD5=82de97da58776ee561cceab097c34ac0"
        DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/doxygen/src/doxygen-1.10.0"
        CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH:LIST=${CMAKE_PREFIX_PATH}
        -DCMAKE_FIND_ROOT_PATH:LIST=${CMAKE_FIND_ROOT_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
)

# Required for grpc example
ExternalProject_Add(grpc
        PREFIX grpc
        GIT_REPOSITORY "https://github.com/grpc/grpc.git"
        GIT_TAG "v1.62.1"
        DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/"
        SOURCE_DIR "${CMAKE_BINARY_DIR}/grpc/src/v1.62.1"
        CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_CROSSCOMPILING:BOOL=OFF
        CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH:LIST=${CMAKE_PREFIX_PATH}
        -DCMAKE_FIND_ROOT_PATH:LIST=${CMAKE_FIND_ROOT_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DgRPC_INSTALL:BOOL=ON
        -DgRPC_BUILD_TESTS:BOOL=OFF
)
