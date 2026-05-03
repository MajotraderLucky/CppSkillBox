cmake_minimum_required(VERSION 3.15)
project(M34_Task1_QtSetup CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt setup. CMAKE_PREFIX_PATH либо берётся из ENV (QT5_PREFIX),
# либо подразумевается что find_package сам найдёт Qt в системе.
if (DEFINED ENV{QT5_PREFIX})
    set(CMAKE_PREFIX_PATH "$ENV{QT5_PREFIX}")
endif()

# Workaround: на CI/sandbox без libgl-dev добавляем stub-include
# (наш widgets-only пример OpenGL не использует, но Qt5GuiConfigExtras
# проверяет наличие GL/gl.h на этапе configure).
if (DEFINED ENV{QT5_GL_INCLUDE_DIR})
    set(CMAKE_INCLUDE_PATH "$ENV{QT5_GL_INCLUDE_DIR}")
    include_directories("$ENV{QT5_GL_INCLUDE_DIR}")
endif()

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

add_executable(qtsetup src/main.cpp)
target_link_libraries(qtsetup
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets)
