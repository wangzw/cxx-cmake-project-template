if (DEMO_ENABLE_DOCUMENT)
    FIND_PACKAGE(Doxygen REQUIRED)

    configure_file(${CMAKE_SOURCE_DIR}/docs/theme/header.html.in ${CMAKE_SOURCE_DIR}/docs/theme/header.html @ONLY)

    set(DOXYGEN_EXCLUDE_PATTERNS "*_test.cpp" "*/detail/*" ${CMAKE_SOURCE_DIR}/docs/theme)
    set(DOXYGEN_EXCLUDE_SYMBOLS "*::detail::*" "std::*")
    set(DOXYGEN_GENERATE_TREEVIEW YES)
    set(DOXYGEN_DISABLE_INDEX NO)
    set(DOXYGEN_FULL_SIDEBAR NO)
    set(DOXYGEN_GENERATE_XML YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_EXTRACT_STATIC YES)
    set(DOXYGEN_STRIP_FROM_PATH ${CMAKE_SOURCE_DIR})

    set(DOXYGEN_HTML_COLORSTYLE LIGHT)
    set(DOXYGEN_HTML_HEADER ${CMAKE_SOURCE_DIR}/docs/theme/header.html)
    set(DOXYGEN_HTML_EXTRA_STYLESHEET
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome.css
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-sidebar-only.css
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-sidebar-only-darkmode-toggle.css
    )
    set(DOXYGEN_HTML_EXTRA_FILES
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-darkmode-toggle.js
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-fragment-copy-button.js
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-interactive-toc.js
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-paragraph-link.js
            ${CMAKE_SOURCE_DIR}/docs/theme/doxygen-awesome-css/doxygen-awesome-tabs.js
    )
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE ${CMAKE_SOURCE_DIR}/README.md)

    doxygen_add_docs(docs
            ${CMAKE_SOURCE_DIR}/README.md
            ${CMAKE_SOURCE_DIR}/docs
            ${CMAKE_SOURCE_DIR}/src/demo
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generate doxygen document."
    )
endif ()
