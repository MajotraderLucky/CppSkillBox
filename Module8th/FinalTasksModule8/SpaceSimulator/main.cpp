#include <iostream>
#include <cmath>
#include <limits>
#include "spacesimulator.h"

int main() {
    float F, m, t;
    getValidInput(F, "Введите силу тяги (F): ");
    getValidInput(m, "Введите массу звездолета (m): ");
    getValidInput(t, "Введите время полета (t): ");

    float a = F / m; // ускорение
    float distance = 0.5 * a * std::pow(t, 2);

    std::cout << "Расстояние от первоначального положения: " << distance << " метров" << std::endl;
    return 0;
}
