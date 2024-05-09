cmake_minimum_required(VERSION 3.27)

demo_add_library(
        TARGET
        demo_output
        HEADERS
        output.h
        FILES
        output.cpp
)

if (DEMO_ENABLE_TEST)
    demo_add_test(
            TARGET
            demo_output_unit
            FILES
            output_test.cpp
    )
    target_link_libraries(demo_output_unit PRIVATE demo_output)
endif ()
