#include "elevator.h"
#include <iostream>
#include <cmath>
#include <limits>

int main() {
    const double DISTANCE_BETWEEN_FLOORS = 3.975;
    const int GROUND_FLOOR = 1;

    std::cout << "Пожалуйста, введите высоту (в метрах): ";
    double height = getValidatedInput(std::cin, std::cout);

    int floorNumber = static_cast<int>(std::floor(height / DISTANCE_BETWEEN_FLOORS));
    if (height >= DISTANCE_BETWEEN_FLOORS) {
        floorNumber += GROUND_FLOOR;
    }

    std::cout << "Номер этажа: " << floorNumber << std::endl;

    return 0;
}
