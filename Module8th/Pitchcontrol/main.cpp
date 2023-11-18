#include "pitchcontrol.h"
#include <iostream>
#include <cmath>

int main() {
    double angleDegrees;
    std::cout << "Введите угол тангажа в градусах: ";
    if (!(std::cin >> angleDegrees)) {
        std::cout << "Ошибка: некорректный ввод.\n";
        return 0;
    }

    double angleRadians = convertDegreesToRadians(fmod(angleDegrees, 360.0));

    std::cout << "-----------------------" << std::endl;
    std::cout << angleRadians << std::endl;
    std::cout << "-----------------------" << std::endl;

    if (angleRadians >= -0.28 && angleRadians <= 0.28) {
        std::cout << "Угол безопасен.\n";
    } else {
        std::cout << "Угол небезопасен!\n";
    }

    return 0;
}
