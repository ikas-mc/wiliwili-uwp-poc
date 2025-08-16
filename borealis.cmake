cmake_minimum_required(VERSION 3.20)

project(borealis)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/borealis/library/cmake/")
set(BOREALIS_PATH "${CMAKE_CURRENT_SOURCE_DIR}/borealis/library")
set(BOREALIS_SOURCE)
set(BOREALIS_SRC)
set(BOREALIS_INCLUDE)
set(BRLS_PLATFORM_LIBS)
set(BRLS_PLATFORM_OPTION)

if (NOT BRLS_RESOURCES_DIR)
    set(BRLS_RESOURCES_DIR ".")
endif ()
set(BRLS_PLATFORM_RESOURCES_PATH "\"${BRLS_RESOURCES_DIR}/resources/\"")

list(APPEND BOREALIS_INCLUDE ${BOREALIS_PATH}/include/compat )
list(APPEND BOREALIS_SOURCE ${BOREALIS_PATH}/lib/platforms/winrt)
list(APPEND BOREALIS_SRC ${BOREALIS_PATH}/lib/platforms/driver/d3d11.cpp)
list(APPEND BOREALIS_SOURCE ${BOREALIS_PATH}/lib/platforms/desktop)

# borealis c/cpp source
list(APPEND BOREALIS_INCLUDE
        ${BOREALIS_PATH}/include
        ${BOREALIS_PATH}/include/borealis/extern
        ${BOREALIS_PATH}/include/borealis/extern/nanovg
        )
list(APPEND BOREALIS_SOURCE
        ${BOREALIS_PATH}/lib/core
        ${BOREALIS_PATH}/lib/core/touch
        ${BOREALIS_PATH}/lib/views
        ${BOREALIS_PATH}/lib/views/cells
        ${BOREALIS_PATH}/lib/views/widgets
        ${BOREALIS_PATH}/lib/extern/glad
        ${BOREALIS_PATH}/lib/extern/libretro-common/compat
        ${BOREALIS_PATH}/lib/extern/libretro-common/encodings
        ${BOREALIS_PATH}/lib/extern/libretro-common/features
        )

# nanovg
list(APPEND BOREALIS_SRC ${BOREALIS_PATH}/lib/extern/nanovg/nanovg.c)

message(STATUS "BOREALIS_SOURCE: ${BOREALIS_SOURCE}")

foreach (lib ${BOREALIS_SOURCE})
    file(GLOB_RECURSE TEMP_SRC "${lib}/*.cpp" "${lib}/*.c")
    list(APPEND BOREALIS_SRC ${TEMP_SRC})
endforeach (lib)

# borealis 图形 driver
set(BOREALIS_DRIVER BOREALIS_USE_D3D11)

list(APPEND BRLS_PLATFORM_OPTION -D${BOREALIS_DRIVER})
message(STATUS "borealis driver ${BOREALIS_DRIVER}")


# borealis Library
add_library(borealis STATIC ${BOREALIS_SRC})

find_package(cppwinrt CONFIG REQUIRED)
target_link_libraries(borealis Microsoft::CppWinRT)

# fmt
find_package(fmt CONFIG REQUIRED)
target_link_libraries(borealis  fmt::fmt)

# tinyxml2
find_package(tinyxml2 CONFIG REQUIRED)
target_link_libraries(borealis  tinyxml2::tinyxml2)

# tweeny ;vcpkg has error
#find_package(Tweeny CONFIG REQUIRED)
add_subdirectory(${BOREALIS_PATH}/lib/extern/tweeny EXCLUDE_FROM_ALL)
target_link_libraries(borealis  tweeny)

# yoga
#find_package(yoga CONFIG REQUIRED)
#target_link_libraries(borealis  yoga::yogacore)

add_subdirectory(${BOREALIS_PATH}/lib/extern/yoga/yoga EXCLUDE_FROM_ALL)
target_compile_options(yogacore PRIVATE -fvisibility=default)
target_link_libraries(borealis  yogacore)


find_package(directxtk CONFIG REQUIRED)
target_link_libraries(borealis  Microsoft::DirectXTK)

list(APPEND BRLS_PLATFORM_LIBS d3d11)
list(APPEND BRLS_PLATFORM_LIBS wlanapi iphlpapi ws2_32)

target_include_directories(borealis PUBLIC ${BOREALIS_INCLUDE})
target_link_libraries(borealis  ${BRLS_PLATFORM_LIBS})
target_compile_options(borealis PUBLIC
        -DBRLS_RESOURCES=${BRLS_PLATFORM_RESOURCES_PATH}
        -DYG_ENABLE_EVENTS
        ${BRLS_PLATFORM_OPTION}
        )
target_compile_definitions(borealis PRIVATE  BOREALIS_USE_STD_THREAD __WINRT__ __WINRT_NEW__ BOREALIS_USE_D3D11 NOMINMAX _SILENCE_ALL_CXX17_DEPRECATION_WARNINGS _WINSOCK_DEPRECATED_NO_WARNINGS _CRT_SECURE_NO_WARNINGS _CRT_NONSTDC_NO_WARNINGS)