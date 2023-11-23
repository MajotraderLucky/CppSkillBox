#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    std::string userInput;
    double number;
    bool stopCommand;

    do {
        std::cout << "Введите количество здоровья орка (от 0.0001 до 1): ";
        std::getline(std::cin, userInput);

        std::pair<double, bool> result = processUserInput(userInput);
        printResult(result);

        number = result.first;
        stopCommand = result.second;

        if (stopCommand == 1) {
            std::cout << "Программа завершена!" << std::endl;
            return 0;
        }

        if (number == 0) {
            std::cout << "Ошибка! Количество здоровья должно быть числом от 0.0001 до 1. Для завершения программы введите 'stop'" << std::endl;
        }

    } while (number == 0);

    std::cout << " Получено число: " << number << std::endl;
    std::cout << " Получена строка: " << stopCommand << std::endl;

    return 0;
}
