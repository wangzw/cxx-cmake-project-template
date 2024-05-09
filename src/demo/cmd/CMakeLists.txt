cmake_minimum_required(VERSION 3.27)

demo_add_executable(
        TARGET
        demo
        FILES
        greeting.h
        greeting.cpp
        main.cpp
)

target_link_libraries(demo PUBLIC demo_common demo_output)
