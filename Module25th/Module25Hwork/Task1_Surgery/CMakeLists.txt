cmake_minimum_required(VERSION 3.17)
project(Surgery VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)

add_executable(surgery src/main.cpp src/tools.cpp include/tools.h)
target_include_directories(surgery PUBLIC include)
