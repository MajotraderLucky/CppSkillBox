#include <iostream>
#include "usersinputcontrol.h"

int main() {
    std::cout << "Hello, World!" << std::endl;

    double initialAmplitude, finalAmplitude;

    processUserInput(
            "Введите начальную амплитуду маятника: ",
            0.1, 1000,
            "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n",
            initialAmplitude
            );
    std::cout << "Вы ввели начальную амплитуду маятника: " << initialAmplitude << std::endl;

    processUserInput(
            "Введите конечную амплитуду маятника: ",
            0.1, 1000,
            "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n",
            finalAmplitude
            );
    std::cout << "Вы ввели конечную амплитуду маятника: " << finalAmplitude << std::endl;
    return 0;
}