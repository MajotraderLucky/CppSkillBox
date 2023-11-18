#include <iostream>
#include <cmath>

int main() {
    const double DISTANCE_BETWEEN_FLOORS = 3.975;
    const int GROUND_FLOOR = 1;

    double height;
    std::cout << "Введите высоту пола кабины над уровнем земли: ";
    std::cin >> height;

    int floorNumber = static_cast<int>(std::floor(height / DISTANCE_BETWEEN_FLOORS));
    if (height >= DISTANCE_BETWEEN_FLOORS) {
        floorNumber += GROUND_FLOOR;
    }

    std::cout << "Номер этажа: " << floorNumber << std::endl;

    return 0;
}
