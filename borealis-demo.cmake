cmake_minimum_required(VERSION 3.20)

# project info
project(borealis-demo-uwp)

set(TEMPLATE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/borealis-demo-uwp/Package.appxmanifest
    ${CMAKE_CURRENT_SOURCE_DIR}/borealis-demo-uwp/Windows_TemporaryKey.pfx
)

file(GLOB_RECURSE PACKAGE_ASSETS_FILES "${CMAKE_CURRENT_SOURCE_DIR}/borealis-demo-uwp/Assets/*")
set_property(SOURCE ${PACKAGE_ASSETS_FILES} PROPERTY VS_DEPLOYMENT_CONTENT 1)
set_property(SOURCE ${PACKAGE_ASSETS_FILES} PROPERTY VS_DEPLOYMENT_LOCATION "Assets")


file(GLOB_RECURSE MAIN_SRC ${CMAKE_CURRENT_SOURCE_DIR}/borealis/demo/src/*.cpp)

# add resource
set(PROJECT_RESOURCES "${CMAKE_CURRENT_SOURCE_DIR}/borealis/resources")
function(add_deployment_content BASE_PATH FILE)
        set_property(SOURCE ${FILE} PROPERTY VS_TOOL_OVERRIDE None)
        set_property(SOURCE ${FILE} PROPERTY VS_DEPLOYMENT_CONTENT 1)
        get_filename_component(FILE_DIR ${FILE} DIRECTORY ABSOLUTE)
        file(RELATIVE_PATH TARGET_PATH ${BASE_PATH} ${FILE_DIR})
        set_property(SOURCE ${FILE} PROPERTY VS_DEPLOYMENT_LOCATION ${TARGET_PATH})
endfunction(add_deployment_content)

file(GLOB_RECURSE PROJECT_RESOURCES_FILES "${PROJECT_RESOURCES}/*")

foreach(FILE IN LISTS PROJECT_RESOURCES_FILES)
        add_deployment_content("${PROJECT_RESOURCES}/.." "${FILE}")
endforeach()

# target
add_executable(${PROJECT_NAME} WIN32 "${MAIN_SRC}" ${PROJECT_RESOURCES_FILES} ${TEMPLATE_FILES} ${PACKAGE_ASSETS_FILES})
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/borealis/demo/include())

set_target_properties(${PROJECT_NAME} PROPERTIES  VS_GLOBAL_AppxBundle "Always")

target_compile_options(${PROJECT_NAME} PRIVATE -DBRLS_RESOURCES_DIR=".")
target_compile_definitions(${PROJECT_NAME} PRIVATE BOREALIS_USE_STD_THREAD __WINRT__ __WINRT_NEW__ BOREALIS_USE_D3D11 __SDL2__ _WINSOCK_DEPRECATED_NO_WARNINGS _CRT_SECURE_NO_WARNINGS  _CRT_NONSTDC_NO_WARNINGS )

target_link_libraries(${PROJECT_NAME} PRIVATE borealis ${APP_PLATFORM_LIB})
