#include <iostream>

int main() {
    int leftBoundary, rightBoundary;
    double position;

    std::cout << "Введите яркость левой границы градиента: ";
    std::cin >> leftBoundary;

    std::cout << "Введите правую границу градиента: ";
    std::cin >> rightBoundary;

    std::cout << "Введите положение точки между границами: ";
    std::cin >> position;

    // Проверка ввода
    if (leftBoundary < 0 || leftBoundary > 255 || rightBoundary < 0 || rightBoundary > 255 || position < 0 || position > 1) {
        std::cout << "Некорректный ввод." << std::endl;
        return 1;
    }

    double brightness = leftBoundary + (rightBoundary - leftBoundary) * position;
    std::cout << "Яркость точки: " << brightness << std::endl;

    return 0;
}
