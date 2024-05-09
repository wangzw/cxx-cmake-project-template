cmake_minimum_required(VERSION 3.27)

if (DEMO_ENABLE_BENCHMARK)
    add_subdirectory(benchmark)
endif ()

add_subdirectory(function)
