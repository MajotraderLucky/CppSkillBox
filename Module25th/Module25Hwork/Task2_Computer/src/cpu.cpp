#include "cpu.h"
#include "ram.h"

#include <iostream>

void cpuCompute() {
    int sum = 0;
    for (int i = 0; i < RAM_SIZE; ++i) sum += ramRead(i);
    std::cout << "SUM: " << sum << "\n";
}
