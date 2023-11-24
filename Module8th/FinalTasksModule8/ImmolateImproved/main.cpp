#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    std::string userInput;
    double number;
    bool stopCommand;
    double health, resistance, ballPower;


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

    health = number;
    std::cout << "Здоровье орка: " << health << std::endl;

    do {
        std::cout << "Введите сопротивляемость магии орка (от 0.0001 до 1): ";
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
            std::cout << "Ошибка! Количество сопротивляемости должно быть числом от 0.0001 до 1. Для завершения программы введите 'stop'" << std::endl;
        }

    } while (number == 0);

    std::cout << " Получено число: " << number << std::endl;
    std::cout << " Получена строка: " << stopCommand << std::endl;

    resistance = number;
    std::cout << "Здоровье орка: " << health << std::endl;
    std::cout << "Сопротивляемость магии орка: " << resistance << std::endl;

    do {
        std::cout << "Введите мощность огненного  шара (от 0.0001 до 1): ";
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
            std::cout << "Ошибка! Мощность магического шара должна быть числом от 0.0001 до 1. Для завершения программы введите 'stop'" << std::endl;
        }

    } while (number == 0);

    std::cout << " Получено число: " << number << std::endl;
    std::cout << " Получена строка: " << stopCommand << std::endl;

    ballPower = number;
    std::cout << "Здоровье орка: " << health << std::endl;
    std::cout << "Сопротивляемость магии орка: " << resistance << std::endl;
    std::cout << "Мощность магического шара: " << ballPower << std::endl;

    return 0;
}
