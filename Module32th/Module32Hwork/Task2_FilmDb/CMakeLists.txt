cmake_minimum_required(VERSION 3.15)
project(M32_Task2_FilmDb CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# nlohmann/json: используем single header из ~/.local/include
# (при сабмите через replit/standalone — ожидается nlohmann_json через FetchContent)
add_executable(filmdb src/main.cpp)
target_include_directories(filmdb PRIVATE $ENV{HOME}/.local/include)
