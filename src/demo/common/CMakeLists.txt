cmake_minimum_required(VERSION 3.27)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.h.in ${CMAKE_CURRENT_SOURCE_DIR}/version.h)

demo_add_library(
        TARGET
        demo_common
        SHARED
        HEADERS
        version.h
        utils.h
        FILES
        utils.cpp
)

if (DEMO_ENABLE_TEST)
    demo_add_test(
            TARGET
            demo_common_unit
            FILES
            utils_test.cpp
    )
    target_link_libraries(demo_common_unit PRIVATE demo_common)
endif ()
