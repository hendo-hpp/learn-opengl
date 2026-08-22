cmake_minimum_required(VERSION 3.25)
project(LearnOpenGL LANGUAGES C CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(FetchContent)

set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(GLFW_VER "3.5.1")
FetchContent_Declare(
    glfw
    GIT_REPOSITORY https://github.com/glfw/glfw.git
    GIT_TAG ${GLFW_VER}
)
FetchContent_MakeAvailable(glfw)

find_package(OpenGL REQUIRED)

add_executable(${PROJECT_NAME}
    src/main.cpp
    src/callbacks.cpp
    external/glad/glad.c
)

target_include_directories(${PROJECT_NAME} 
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    SYSTEM PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/external/glad/include
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    glfw
    OpenGL::GL
)

include(cmake/format.cmake)