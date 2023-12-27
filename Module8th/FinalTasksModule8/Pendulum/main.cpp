#include <iostream>
#include <stdexcept>
#include "usersinputcontrol.h"

class StopException : public std::exception {
public:
    const char* what() const noexcept override {
        return "Stop exception occurred";
    }
};

int main() {
    double initialAmplitude;
    double finalAmplitude;

    try {
        processUserInput(
                "Введите начальную амплитуду маятника см: ",
                0.1, 1000,
                "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n",
                initialAmplitude
        );
        std::cout << "Вы ввели начальную амплитуду маятника: " << initialAmplitude << " cм." << std::endl;

        processUserInput(
                "Введите конечную амплитуду маятника: ",
                0.1, 1000,
                "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n",
                finalAmplitude
        );
        std::cout << "Вы ввели конечную амплитуду маятника: " << finalAmplitude << " см." << std::endl;

    } catch (const StopException& e) {
        std::cerr << e.what() << std::endl;
        return 0;
    } catch (const std::runtime_error& e) {
        std::cerr << "Вы ввели 'stop': " << e.what() << std::endl;
    }

    return 0;
}