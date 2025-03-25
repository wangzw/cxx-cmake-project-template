include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
        "${PROJECT_NAME}ConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
        "${CMAKE_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(FILES
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(EXPORT ${PROJECT_NAME}-targets
        FILE ${PROJECT_NAME}Targets.cmake
        NAMESPACE ${PROJECT_NAME}::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

export(EXPORT ${PROJECT_NAME}-targets
        FILE "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Targets.cmake"
        NAMESPACE ${PROJECT_NAME}::
)


function(_demo_list_public_header DIR HEADERS)
    set(CURRENT_HEADERS)
    get_property(TGTS DIRECTORY "${DIR}" PROPERTY BUILDSYSTEM_TARGETS)
    foreach (TGT IN LISTS TGTS)
        get_target_property(HEADER_SOURCES ${TGT} HEADER_SET_HEADERS)
        if (HEADER_SOURCES)
            list(APPEND CURRENT_HEADERS ${HEADER_SOURCES})
        endif ()
    endforeach ()

    get_property(SUBDIRS DIRECTORY "${DIR}" PROPERTY SUBDIRECTORIES)
    foreach (SUBDIR IN LISTS SUBDIRS)
        _demo_list_public_header("${SUBDIR}" SUBDIR_HEADERS)
        list(APPEND CURRENT_HEADERS ${SUBDIR_HEADERS})
    endforeach ()

    set(${HEADERS} ${CURRENT_HEADERS} PARENT_SCOPE)
endfunction()

function(demo_check_public_header)
    _demo_list_public_header(${CMAKE_SOURCE_DIR} HEADERS)
    add_custom_target(check_public_header
            COMMAND ${CMAKE_SOURCE_DIR}/cmake/scripts/check-header.py
            ${PROJECT_SOURCE_DIR}/src
            ${HEADERS}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            VERBATIM # Protect arguments to commands
            COMMENT "Check integrity of installed headers."
    )
endfunction()

demo_check_public_header()
