#include "kbd.h"
#include "ram.h"

#include <iostream>

bool kbdInput() {
    for (int i = 0; i < RAM_SIZE; ++i) {
        int v = 0;
        if (!(std::cin >> v)) return false;
        ramWrite(i, v);
    }
    return true;
}
