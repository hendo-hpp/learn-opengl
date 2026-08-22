cmake_minimum_required(VERSION 3.25)

option(ENABLE_CLANG_FORMAT "Enable clang-format targets" ON)
option(ENABLE_CLANG_TIDY   "Enable clang-tidy targets"   ON)

set(CLANG_FORMAT_BIN "clang-format" CACHE STRING "clang-format binary")
set(CLANG_TIDY_BIN   "clang-tidy"   CACHE STRING "clang-tidy binary")

# clang-format inputs
file(GLOB_RECURSE FORMAT_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
)

# clang-tidy inputs
file(GLOB_RECURSE TIDY_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

if(ENABLE_CLANG_FORMAT)
    find_program(CLANG_FORMAT_EXE NAMES ${CLANG_FORMAT_BIN} clang-format)
    if(NOT CLANG_FORMAT_EXE)
        message(FATAL_ERROR "clang-format not found.")
    endif()

    add_custom_target(format
        COMMAND "${CLANG_FORMAT_EXE}" -i -style=file ${FORMAT_FILES}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )

    add_custom_target(format-check
        COMMAND "${CLANG_FORMAT_EXE}" --dry-run --Werror -style=file ${FORMAT_FILES}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endif()

if(ENABLE_CLANG_TIDY)
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

    find_program(CLANG_TIDY_EXE NAMES ${CLANG_TIDY_BIN} clang-tidy)
    if(NOT CLANG_TIDY_EXE)
        message(FATAL_ERROR "clang-tidy not found.")
    endif()

    set(CLANG_TIDY_CONFIG "${CMAKE_CURRENT_SOURCE_DIR}/.clang-tidy")

    set(CLANG_TIDY_EXTRA_ARGS "")
    if(EXISTS "${CLANG_TIDY_CONFIG}")
        list(APPEND CLANG_TIDY_EXTRA_ARGS "--config-file=${CLANG_TIDY_CONFIG}")
    endif()

    add_custom_target(tidy
        COMMAND "${CLANG_TIDY_EXE}"
                ${CLANG_TIDY_EXTRA_ARGS}
                -p "${CMAKE_BINARY_DIR}"
                --quiet
                ${TIDY_FILES}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endif()
