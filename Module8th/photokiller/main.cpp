#include <iostream>
#include <limits>
#include "photokiller.h"

int main() {
    int leftBoundary, rightBoundary;
    double position;

    std::cout << "Введите яркость левой границы градиента: ";
    std::cin >> leftBoundary;
    if (leftBoundary < 0 || leftBoundary > 255 || std::cin.fail()) {
        std::cout << "Некорректный ввод." << std::endl;
        return 1;
    }
    clearInputBuffer();

    std::cout << "Введите правую границу градиента: ";
    std::cin >> rightBoundary;
    if (rightBoundary < 0 || rightBoundary > 255 || std::cin.fail()) {
        std::cout << "Некорректный ввод." << std::endl;
        return 1;
    }
    clearInputBuffer();

    std::cout << "Введите положение точки между границами: ";
    std::cin >> position;
    if (!validateInput(position)) {
        std::cout << "Некорректный ввод." << std::endl;
        return 1;
    }

    double brightness = leftBoundary + (rightBoundary - leftBoundary) * position;
    std::cout << "Яркость точки: " << brightness << std::endl;

    return 0;
}
