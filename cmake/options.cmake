set(DEMO_BUILD_NUMBER "dev" CACHE STRING "build number")

option(DEMO_ENABLE_TEST "enable test" OFF)
option(DEMO_ENABLE_BENCHMARK "enable test" OFF)
option(DEMO_ENABLE_EXAMPLE "enable test" OFF)
option(DEMO_ENABLE_DOCUMENT "enable document" OFF)
option(DEMO_ENABLE_COVERAGE "enable code coverage" OFF)
option(DEMO_ENABLE_CLANG_TIDY "enable clang-tidy check" OFF)
option(DEMO_ENABLE_SANITIZERS "enable sanitizer" OFF)

option(SANITIZE_ADDRESS "enable sanitizer address" ON)
option(SANITIZE_MEMORY "enable sanitizer memory" OFF) # only with clang
option(SANITIZE_THREAD "enable sanitizer thread" OFF) # conflict with others
option(SANITIZE_UNDEFINED "enable sanitizer undefined" ON)

option(DEMO_WITH_GRPC "build grpc" OFF)
