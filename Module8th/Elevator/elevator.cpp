#include "elevator.h"

#include <iostream>
#include <limits>

double getValidatedInput(std::istream& input, std::ostream& output) {
    double height;
    while (!(input >> height) || height <= 0) {
        output << "Неверный ввод. Пожалуйста, введите положительное число: ";
        input.clear();
        input.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    }
    return height;
}