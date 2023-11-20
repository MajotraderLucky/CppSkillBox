#include "spacesimulator.h"

void getValidInput(float& number, const std::string& prompt) {
    std::cout << prompt;
    while(!(std::cin >> number) || number <= 0) {
        std::cin.clear();
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cout << "Введено неверное значение. Пожалуйста, введите положительное число: ";
    }
}
