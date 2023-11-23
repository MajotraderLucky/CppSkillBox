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

    std::pair<double, bool> values = processUserInput(userInput);
    double number = values.first;
    bool stopCommand = values.second;

    std::cout << " Получено число: " << number << std::endl;
    std::cout << " Получена строка: " << stopCommand << std::endl;

    return 0;
}
