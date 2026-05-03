#include "cpu.h"
#include "disk.h"
#include "gpu.h"
#include "kbd.h"

#include <iostream>
#include <string>

int main() {
    std::cerr << "Команды: input/sum/save/load/display/exit\n";
    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "exit") {
            std::cout << "EXIT\n";
            return 0;
        } else if (cmd == "input") {
            if (!kbdInput()) return 1;
            std::cout << "INPUT OK\n";
        } else if (cmd == "sum") {
            cpuCompute();
        } else if (cmd == "save") {
            std::cout << (diskSave() ? "SAVE OK" : "SAVE FAIL") << "\n";
        } else if (cmd == "load") {
            std::cout << (diskLoad() ? "LOAD OK" : "LOAD FAIL") << "\n";
        } else if (cmd == "display") {
            gpuDisplay();
        } else {
            std::cerr << "Неизвестная команда: " << cmd << "\n";
        }
    }
    return 0;
}
