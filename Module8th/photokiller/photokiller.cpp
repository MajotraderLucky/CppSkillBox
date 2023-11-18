#include <iostream>
#include <limits>
#include "photokiller.h"

void clearInputBuffer() {
    std::cin.clear();
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

double getInput() {
    double input;
    while (!(std::cin >> input) || !validateInput(input)) {
        std::cerr << "Invalid input. Please try again.\n";
        clearInputBuffer();
    }
    return input;
}

bool validateInput(double input) {
    return (input >= 0 && input <= 1);
}
