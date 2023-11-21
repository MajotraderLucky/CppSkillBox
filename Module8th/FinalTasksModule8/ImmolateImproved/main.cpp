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
} else if (!containsDigitsAndDot(userInput).empty()) {
    std::cout << "Строка содержит цифры и точку.\n";
} else {
    std::cout << "Строка содержит символы, отличные от цифр и точки.\n";
}

    return 0;
}
