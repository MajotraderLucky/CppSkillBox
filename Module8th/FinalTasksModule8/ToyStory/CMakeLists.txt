cmake_minimum_required(VERSION 3.26)
project(ToyStory)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(ToyStory
        main.cpp
        usersinputcontrol.cpp
        usersinputcontrol.h)
