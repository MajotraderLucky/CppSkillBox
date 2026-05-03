add_executable(computer
    main.cpp
    cpu.cpp
    ram.cpp
    disk.cpp
    gpu.cpp
    kbd.cpp
)

target_include_directories(computer PUBLIC ${COMPUTER_INCLUDE_DIR})
