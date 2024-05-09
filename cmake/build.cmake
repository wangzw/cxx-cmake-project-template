# setup sanitizers and coverage
if (DEMO_ENABLE_SANITIZERS)
    find_package(Sanitizers REQUIRED)
endif ()

if (DEMO_ENABLE_COVERAGE)
    include(coverage)

    setup_target_for_coverage_gcovr_html(
            NAME coverage
            BASE_DIRECTORY "${CMAKE_SOURCE_DIR}"
            EXCLUDE ${CMAKE_BINARY_DIR}/* ${CMAKE_SOURCE_DIR}/src/tests/* ${CMAKE_SOURCE_DIR}/\\.*_test.cpp
    )
    setup_target_for_coverage_gcovr_xml(
            NAME coverage-xml
            BASE_DIRECTORY "${CMAKE_SOURCE_DIR}"
            EXCLUDE ${CMAKE_BINARY_DIR}/* ${CMAKE_SOURCE_DIR}/src/tests/* ${CMAKE_SOURCE_DIR}/\\.*_test.cpp
    )

    set(DEMO_COVERAGE_TARGETS coverage coverage-xml)
endif ()

# setup clang-tidy
if (DEMO_ENABLE_CLANG_TIDY)
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy" REQUIRED)
    list(TRANSFORM EXTRA_CLANG_TIDY_COMPILER_FLAGS PREPEND "EXTRA_CLANG_TIDY_COMPILER_FLAGS=")
    set(CLANG_TIDY_COMMAND "${CMAKE_SOURCE_DIR}/clang-tidy-wrap" "${CLANG_TIDY_EXE}" ${EXTRA_CLANG_TIDY_COMPILER_FLAGS})
endif ()

# function used to add a library with clang-tidy, sanitizers and coverage configure
function(demo_add_library)
    cmake_parse_arguments(PARSE_ARGV 0 AAL "SHARED" "TARGET" "HEADERS;FILES")

    if (AAL_SHARED)
        add_library(${AAL_TARGET} SHARED)
        set_target_properties(${AAL_TARGET} PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
    else ()
        add_library(${AAL_TARGET} STATIC)
    endif ()

    target_sources(${AAL_TARGET}
            PUBLIC FILE_SET HEADERS
            BASE_DIRS ${CMAKE_SOURCE_DIR}/src
            FILES
            ${AAL_HEADERS}
            PRIVATE
            ${AAL_FILES}
    )

    set_target_properties(${AAL_TARGET} PROPERTIES LINKER_LANGUAGE CXX)

    target_include_directories(${AAL_TARGET}
            PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )

    if (DEMO_ENABLE_CLANG_TIDY)
        set_target_properties(${AAL_TARGET} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}")
    endif ()

    if (DEMO_ENABLE_SANITIZERS AND AAL_FILES)
        add_sanitizers(${AAL_TARGET})
    endif ()

    if (DEMO_ENABLE_COVERAGE)
        append_coverage_compiler_flags_to_target(${AAL_TARGET})

        foreach (COVERAGE_TARGET IN LISTS DEMO_COVERAGE_TARGETS)
            add_dependencies(${COVERAGE_TARGET} ${AAL_TARGET})
        endforeach ()
    endif ()

    install(TARGETS ${AAL_TARGET}
            EXPORT ${PROJECT_NAME}-targets
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
endfunction()

function(demo_add_executable)
    cmake_parse_arguments(PARSE_ARGV 0 AAL "" "TARGET" "HEADERS;FILES")
    add_executable(${AAL_TARGET})

    target_sources(${AAL_TARGET}
            PUBLIC FILE_SET HEADERS
            BASE_DIRS ${CMAKE_SOURCE_DIR}/src
            FILES
            ${AAL_HEADERS}
            PRIVATE
            ${AAL_FILES}
    )

    set_target_properties(${AAL_TARGET} PROPERTIES LINKER_LANGUAGE CXX)

    target_include_directories(${AAL_TARGET}
            PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )

    if (DEMO_ENABLE_CLANG_TIDY)
        set_target_properties(${AAL_TARGET} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}")
    endif ()

    if (DEMO_ENABLE_SANITIZERS AND AAL_FILES)
        add_sanitizers(${AAL_TARGET})
    endif ()

    if (DEMO_ENABLE_COVERAGE)
        append_coverage_compiler_flags_to_target(${AAL_TARGET})

        foreach (COVERAGE_TARGET IN LISTS DEMO_COVERAGE_TARGETS)
            add_dependencies(${COVERAGE_TARGET} ${AAL_TARGET})
        endforeach ()
    endif ()

    install(TARGETS ${AAL_TARGET}
            EXPORT ${PROJECT_NAME}-targets
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
endfunction()

function(demo_add_example)
    cmake_parse_arguments(PARSE_ARGV 0 AAL "" "TARGET" "FILES")
    add_executable(${AAL_TARGET} ${AAL_FILES})

    if (DEMO_ENABLE_SANITIZERS AND AAL_FILES)
        add_sanitizers(${AAL_TARGET})
    endif ()
endfunction()

if (DEMO_ENABLE_TEST)
    # setup google test and ctest
    find_package(GTest REQUIRED)
    include(GoogleTest)
    set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
    include(CTest)

    # add a unit test with sanitizers and coverage configure
    function(demo_add_test)
        cmake_parse_arguments(PARSE_ARGV 0 AAL "" "TARGET" "FILES")
        add_executable(${AAL_TARGET} ${AAL_FILES})
        set_target_properties(${AAL_TARGET} PROPERTIES LINKER_LANGUAGE CXX)
        target_link_libraries(${AAL_TARGET} PRIVATE GTest::gtest_main GTest::gmock)
        gtest_discover_tests(${AAL_TARGET})

        if (DEMO_ENABLE_SANITIZERS)
            add_sanitizers(${AAL_TARGET})
        endif ()

        if (DEMO_ENABLE_COVERAGE)
            append_coverage_compiler_flags_to_target(${AAL_TARGET})

            foreach (COVERAGE_TARGET IN LISTS DEMO_COVERAGE_TARGETS)
                add_dependencies(${COVERAGE_TARGET} ${AAL_TARGET})
            endforeach ()
        endif ()
    endfunction()
endif ()

#setup benchmark test
if (DEMO_ENABLE_BENCHMARK)
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Running benchmark with Debug build may be misleading")
    endif ()

    find_package(benchmark REQUIRED)
    # target used to run all benchmark
    add_custom_target(benchmark)

    function(demo_add_benchmark)
        cmake_parse_arguments(PARSE_ARGV 0 AAL "" "TARGET" "FILES")
        add_executable(${AAL_TARGET} ${AAL_FILES})
        target_link_libraries(${AAL_TARGET} PRIVATE benchmark::benchmark_main)

        add_custom_target(run_${AAL_TARGET}
                COMMAND $<TARGET_FILE:${AAL_TARGET}>
                --benchmark_out=${AAL_TARGET}.json
                --benchmark_out_format=json
                # Set output files as GENERATED (will be removed on 'make clean')
                DEPENDS ${AAL_TARGET}
                BYPRODUCTS
                ${AAL_TARGET}.json
                WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                VERBATIM # Protect arguments to commands
                COMMENT "Run benchmark ${AAL_TARGET} and output result as json format."
        )

        add_dependencies(benchmark run_${AAL_TARGET})
    endfunction()
endif ()
