cmake_minimum_required(VERSION 3.10)
project(ImmolateImproved)

set(CMAKE_CXX_STANDARD 14)

# Добавляем поддиректорию с Google Test
add_subdirectory(/usr/src/googletest googletest-build)

# Указываем включить заголовочные файлы Google Test
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

add_executable(ImmolateImproved main.cpp usersinputcontrol.cpp unittests/usersinputcontrol_unittests.cpp)

# Связываем наш исполняемый файл с библиотеками Google Test
target_link_libraries(ImmolateImproved gtest gtest_main)
