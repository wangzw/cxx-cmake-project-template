# /opt/devel-toolchain.cmake is predefined toolchain in dev container image.

if (EXISTS /opt/devel-toolchain.cmake)
    include(/opt/devel-toolchain.cmake)
endif ()
