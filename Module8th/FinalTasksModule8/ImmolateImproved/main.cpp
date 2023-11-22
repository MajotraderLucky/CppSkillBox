#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    std::string userInput;

    std::cout << "Введите количество здоровья орка (от 0.0001 до 1): ";
    std::getline(std::cin, userInput);

    std::pair<double, bool> result = processUserInput(userInput);
    printResult(result);

    return 0;
}
