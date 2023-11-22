#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    std::string userInput;

    std::cout << "Введите строку: ";
    std::getline(std::cin, userInput);

    processUserInput(userInput);

    return 0;
}
