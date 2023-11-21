#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    std::string userInput;

    std::cout << "Введите строку: ";
    std::getline(std::cin, userInput);

if (isDigitsOnly(userInput)) {
    std::cout << "Строка состоит только из цифр.\n";
    double number = convertToDouble(userInput);
    bool insideTheRange = isInRange(number, 0.000001, 1.0);
    if (insideTheRange) {
        std::cout << "Введенное число в диапазоне от 0.000001 до 1.0\n";
    } else {
        std::cout << "Введенное число не в диапазоне от 0.000001 до 1.0\n";
    }
} else if (!containsDigitsAndDot(userInput).empty()) {
    std::cout << "Строка содержит цифры и точку.\n";
    double value = convertToDouble(userInput);
    bool insideTheRange = isInRange(value, 0.000001, 1.0);
    if (insideTheRange) {
        std::cout << "Введенное число в диапазоне от 0.000001 до 1.0\n";
    } else {
        std::cout << "Введенное число не в диапазоне от 0.000001 до 1.0\n";
    }
} else {
    std::cout << "Строка содержит символы, отличные от цифр и точки.\n";
}

    return 0;
}
