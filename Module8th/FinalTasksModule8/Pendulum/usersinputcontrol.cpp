#include "usersinputcontrol.h"
#include <cctype> // for isdigit() function
#include <iostream>
#include <string>
#include <vector>

bool isDigitsOnly(const std::string& input) {
    size_t start = 0;
    if (!input.empty() && input.front() == '-') {
        start = 1;
    }

    for (size_t i = start; i < input.size(); i++) {
        if (!std::isdigit(input[i])) {
            return false;
        }
    }
    return true;
}

std::string containsDigitsAndDot(const std::string& input) {
    bool hasOneDot = false;

    size_t start = 0;
    if (!input.empty() && input.front() == '-') {
        start = 1;
    }

    // проверка на наличие точки в начале и в конце строки
    if (input[start] == '.' || input.back() == '.') {
        return "";
    }

    for (size_t i = start; i < input.size(); i++) {
        if (std::isdigit(input[i])) {
            continue;
        } else if (input[i] == '.' && !hasOneDot) {
            hasOneDot = true;
        } else {
            return "";
        }
    }

    if (hasOneDot)
        return input;

    return "";  // Возвращаем пустую строку, если в строке нет точки
}

double convertToDouble(const std::string& input) {
    if (input.empty()) {
        return 0.0;
    }

    try {
        return std::stod(input);
    } catch (const std::exception& e) {
        return 0.0;
    }
}

bool isInRange(double number, double lowerBound, double upperBound) {
    if (number >= lowerBound && number <= upperBound) {
        return true;
    }
    return false;
}

bool compareStrings(const std::string& str1, const std::string& str2) {
    return str1 == str2;
}

void processUserInput(const std::string& prompt, double min, double max, const std::string& errorMessage, double& output) {
    while (true) {
        std::cout << prompt;
        std::string userInput;
        std::cin >> userInput;

        if (isDigitsOnly(userInput)) {
            double number = convertToDouble(userInput);
            if (isInRange(number, min, max)) {
                output = number;
                return;
            }
        } else if (!containsDigitsAndDot(userInput).empty()) {
            double number = convertToDouble(userInput);
            if (isInRange(number, min, max)) {
                output = number;
                return;
            }
        } else if (compareStrings(userInput, "stop")) {
            throw std::runtime_error("Программа завершена.");
        }

        std::cout << errorMessage;
    }
}
