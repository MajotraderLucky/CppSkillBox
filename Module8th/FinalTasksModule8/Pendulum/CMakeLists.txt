cmake_minimum_required(VERSION 3.27)
project(Pendulum)

set(CMAKE_CXX_STANDARD 14)

add_executable(Pendulum
        main.cpp
        usersinputcontrol.h
        usersinputcontrol.cpp)
