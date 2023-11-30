#include <iostream>
#include <string>
#include <cctype> // Для функции isdigit()
#include "usersinputcontrol.h"

int main() {
    double  x, y, z;

    std::pair<double, bool> userInput;

    userInput = getUserInput(
            "Введите толщину бруска см: (от 5 до 100 000 сантиметров): ",
            5, 100000,
            "Ошибка! Число не принадлележит заданному диапазону. Для завершения программы введите 'stop'\n"
    );
    if (userInput.second) return 0;
    x = userInput.first;

    userInput = getUserInput(
            "Введите длину бруска см: (от 5 до 100 000 сантиметров): ",
            5, 100000,
            "Ошибка! Число не принадлележит заданному диапазону. Для завершения программы введите'stop'\n"
    );
    if (userInput.second) return 0;
    y = userInput.first;

    userInput = getUserInput(
            "Введите ширину бруска см: (от 5 до 100 000 сантиметров): ",
            5, 100000,
            "Ошибка! Число не принадлележит заданному диапазону. Для завершения программы введите'stop'\n"
    );
    if (userInput.second) return 0;
    z = userInput.first;

    std::cout << "Толщина бруска см: " << x << std::endl;
    std::cout << "Длина бруска см: " << y << std::endl;
    std::cout << "Ширина бруска см: " << z << std::endl;

    return 0;
}