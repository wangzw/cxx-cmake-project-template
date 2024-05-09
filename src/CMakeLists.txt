cmake_minimum_required(VERSION 3.27)

add_subdirectory(demo)

if (DEMO_ENABLE_TEST)
    add_subdirectory(tests)
endif ()

if (DEMO_ENABLE_EXAMPLE)
    add_subdirectory(examples)
endif ()
