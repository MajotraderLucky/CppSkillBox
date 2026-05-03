#include <iostream>
#include <string>

// Task 2 — Сшиватель дробных чисел (M16.6 hwork)
// Из целой и дробной частей собрать double через std::stod.

int main() {
    std::string intPart, fracPart;
    std::cerr << "Enter integer part: ";
    if (!(std::cin >> intPart)) {
        std::cerr << "Invalid integer part" << std::endl;
        return 1;
    }
    std::cerr << "Enter fractional part: ";
    if (!(std::cin >> fracPart)) {
        std::cerr << "Invalid fractional part" << std::endl;
        return 1;
    }
    std::string combined = intPart + "." + fracPart;
    try {
        double value = std::stod(combined);
        std::cout << value << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "stod failed: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}
