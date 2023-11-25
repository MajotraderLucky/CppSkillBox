#include "usersinputcontrol.hpp"
#include <cctype> // for isdigit() function
#include <iostream>
#include <string>
#include <utility>

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

std::pair<double, bool> processUserInput(const std::string& userInput) {
    double number = 0.0;
    bool stopCommand = false;

    if (isDigitsOnly(userInput)) {
        number = convertToDouble(userInput);
        if (isInRange(number, 0.0001, 1.0)) {
            return std::make_pair(number, stopCommand);
        }
    } else if (!containsDigitsAndDot(userInput).empty()) {
        number = convertToDouble(userInput);
        if (isInRange(number, 0.0001, 1.0)) {
            return std::make_pair(number, stopCommand);
        }
    } else if (compareStrings(userInput, "stop")) {
        stopCommand = true;
    }

    return std::make_pair(0.0, stopCommand);
}

void printResult(const std::pair<double, bool>& result) {
    std::cout << "Number: " << result.first << std::endl;
    std::cout << "Stop Command: " << (result.second ? "true" : "false") << std::endl;
}

std::pair<double, bool> getUserInput(
    const std::string& prompt, 
    double min, double max, 
    const std::string& errorMsg) 
{
    std::string userInput;
    std::pair<double, bool> result;

    do {
        std::cout << prompt;
        std::getline(std::cin, userInput);

        result = processUserInput(userInput);

        if (result.second) { // Проверяем stopCommand
            return result;
        }

        if (result.first < min || result.first > max) {
            std::cout << errorMsg;
            // Устанавливаем result.first в 0, чтобы while продолжил цикл
            result.first = 0;
        }

    } while (result.first == 0);

    return result;
}

