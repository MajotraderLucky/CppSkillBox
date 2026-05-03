#include "ram.h"

namespace {
    int g_ram[RAM_SIZE] = {0};
}

void ramWrite(int index, int value) {
    if (index < 0 || index >= RAM_SIZE) return;
    g_ram[index] = value;
}

int ramRead(int index) {
    if (index < 0 || index >= RAM_SIZE) return 0;
    return g_ram[index];
}
