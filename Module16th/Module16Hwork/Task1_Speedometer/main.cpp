#include <iostream>
#include <cstdio>
#include <string>

// Task 1 — Спидометр (M16.6 hwork)
// Начальная скорость 0, диапазон 0..150. Пользователь вводит дельту.
// Выход когда speed <= 0.01 (после применения дельты).
// sprintf для форматирования с 1 знаком после точки.

int main() {
    double speed = 0.0;
    double delta;
    do {
        std::cerr << "Speed delta: ";
        if (!(std::cin >> delta)) {
            std::cerr << "Invalid input" << std::endl;
            return 1;
        }
        speed += delta;
        if (speed > 150.0) speed = 150.0;
        if (speed < 0.0) speed = 0.0;

        char buf[64];
        std::sprintf(buf, "Speed: %.1f", speed);
        std::cout << buf << std::endl;
    } while (speed > 0.01);
    return 0;
}
