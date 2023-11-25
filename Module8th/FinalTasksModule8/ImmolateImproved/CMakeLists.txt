cmake_minimum_required(VERSION 3.10)
project(ImmolateImproved)

set(CMAKE_CXX_STANDARD 14)

# Добавляем поддиректорию с Google Test
add_subdirectory(/usr/src/googletest googletest-build)

# Указываем включить заголовочные файлы Google Test
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

enable_testing()

# Создаем исполняемый файл для основной программы
add_executable(ImmolateImproved main.cpp usersinputcontrol.cpp)

# Создаем исполняемый файл для тестов
add_executable(ImmolateImprovedTests unittests/usersinputcontrol_unittests.cpp usersinputcontrol.cpp)

# Связываем тестовый исполняемый файл с библиотеками Google Test
target_link_libraries(ImmolateImprovedTests gtest gtest_main)

# Добавляем тесты
add_test(NAME ImmolateImprovedTest COMMAND ImmolateImprovedTests)
