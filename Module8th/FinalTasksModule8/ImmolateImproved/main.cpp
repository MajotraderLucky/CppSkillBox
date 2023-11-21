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
    int numberInt = std::atoi(userInput.c_str());
    std::cout << "Строка была преобразована в int: " << numberInt << "\n";
} else if (!containsDigitsAndDot(userInput).empty()) {
    std::cout << "Строка содержит цифры и точку.\n";
    double value = convertToDouble(userInput);
    std::cout << "Строка была преобразована в double: " << value << "\n";
} else {
    std::cout << "Строка содержит символы, отличные от цифр и точки.\n";
}

    return 0;
}
