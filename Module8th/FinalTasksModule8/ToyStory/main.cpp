#include <iostream>
#include <string>
#include <complex>
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

    int num_cubes = (int)(x / 5) * (int)(y / 5) * (int)(z / 5);
    std::cout << "Из этого бруска можно изготовить " << num_cubes << " кубиков.\n";

    int max_set_size = pow((int)cbrt(num_cubes), 3);
    std::cout << "Из них можно составить набор из " << max_set_size << " кубиков.\n";

    return 0;
}