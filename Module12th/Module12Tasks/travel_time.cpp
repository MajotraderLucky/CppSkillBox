#include <iostream>
#include <cassert>

float travelTime(float distance, float speed) {
    // Assert проверяет, что скорость положительная
    assert(speed > 0);
    
    // Вычисляем время в пути
    return distance / speed;
}

int main() {
    std::cout << "=== Программа расчета времени в пути ===" << std::endl;
    
    float distance, speed;
    
    std::cout << "Введите расстояние (км): ";
    std::cin >> distance;
    
    std::cout << "Введите скорость (км/ч): ";
    std::cin >> speed;
    
    // Вызываем функцию, которая использует assert
    float time = travelTime(distance, speed);
    
    std::cout << "Время в пути: " << time << " часов" << std::endl;
    
    return 0;
}