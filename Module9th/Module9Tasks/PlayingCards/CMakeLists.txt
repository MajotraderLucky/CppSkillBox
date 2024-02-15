cmake_minimum_required(VERSION 3.26)
project(PlayCards)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(PlayCards
          main.cpp
          playingcards.cpp
          playingcards.h)