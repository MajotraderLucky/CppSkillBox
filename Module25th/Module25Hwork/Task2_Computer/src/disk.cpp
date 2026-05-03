#include "disk.h"
#include "ram.h"

#include <fstream>

constexpr const char* DATA_FILE = "data.txt";

bool diskSave() {
    std::ofstream f(DATA_FILE);
    if (!f.is_open()) return false;
    for (int i = 0; i < RAM_SIZE; ++i) {
        f << ramRead(i);
        if (i + 1 < RAM_SIZE) f << " ";
    }
    f << "\n";
    return true;
}

bool diskLoad() {
    std::ifstream f(DATA_FILE);
    if (!f.is_open()) return false;
    for (int i = 0; i < RAM_SIZE; ++i) {
        int v = 0;
        if (!(f >> v)) return false;
        ramWrite(i, v);
    }
    return true;
}
