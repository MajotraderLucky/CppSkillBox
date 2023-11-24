#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.hpp"

int main() {
    double health, resistance, ballPower;

    std::pair<double, bool> userInput;

    userInput = getUserInput(
        "Введите количество здоровья орка (от 0.0001 до 1): ",
        0.0001, 1,
        "Ошибка! Количество здоровья должно быть числом от 0.0001 до 1. Для завершения программы введите 'stop'\n"
    );
    if (userInput.second) return 0;
    health = userInput.first;

    userInput = getUserInput(
        "Введите сопротивляемость магии орка (от 0.0001 до 1): ",
        0.0001, 1,
        "Ошибка! Сопротивляемость магии должна быть числом от 0.0001 до 1. Для завершения программы введите 'stop'\n"
    );
    if (userInput.second) return 0;
    resistance = userInput.first;

    userInput = getUserInput(
        "Введите мощность магического шара (от 0.0001 до 1): ",
        0.0001, 1,
        "Ошибка! Мощность магического шара должна быть числом от 0.0001 до 1. Для завершения программы введите 'stop'\n"
    );
    if (userInput.second) return 0;
    ballPower = userInput.first;

    std::cout << "Здоровье орка: " << health << "\n";
    std::cout << "Сопротивляемость магии орка: " << resistance << "\n";
    std::cout << "Мощность магического шара: " << ballPower << "\n";

    return 0;
}