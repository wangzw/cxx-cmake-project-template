cmake_minimum_required(VERSION 3.27)

demo_add_benchmark(
        TARGET
        memcpy_benchmark
        FILES
        memcpy_benchmark.cpp
)

target_link_libraries(memcpy_benchmark PRIVATE demo_common)
