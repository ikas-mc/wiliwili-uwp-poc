cmake_minimum_required(VERSION 3.20)
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")

# https://cmake.org/cmake/help/latest/generator/Visual%20Studio%2017%202022.html
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-windows-10-universal-applications
set(CMAKE_SYSTEM_NAME WindowsStore)
set(CMAKE_SYSTEM_VERSION 10.0)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

#CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION
#CMAKE_VS_PLATFORM_NAME

project(wiliwili-uwp-poc)

include(borealis.cmake)

include(borealis-demo.cmake)

include(wiliwili.cmake)