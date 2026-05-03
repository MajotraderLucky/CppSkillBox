#include "gpu.h"
#include "ram.h"

#include <iostream>

void gpuDisplay() {
    std::cout << "GPU:";
    for (int i = 0; i < RAM_SIZE; ++i) {
        std::cout << " " << ramRead(i);
    }
    std::cout << "\n";
}
