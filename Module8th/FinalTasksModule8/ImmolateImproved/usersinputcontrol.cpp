#include "usersinputcontrol.hpp"
#include <cctype> // for isdigit() function
#include <iostream>
#include <string>

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
        // Пустая строка не может быть преобразована в число.
        // В данном случае можно выбросить исключение, вернуть значение по умолчанию или сделать что-то другое в зависимости от конкретных требований.
        // В данном примере вернем 0.
        return 0.0;
    }
    
    try {
        return std::stod(input);
    } catch (const std::exception& e) {
        // Произошла ошибка преобразования строки в число.
        // В данном случае можно выбросить исключение, вернуть значение по умолчанию или сделать что-то другое в зависимости от конкретных требований.
        // В данном примере вернем 0.
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

void processUserInput(const std::string& userInput) {
    if (isDigitsOnly(userInput)) {
        double number = convertToDouble(userInput);
        bool insideTheRange = isInRange(number, 0.000001, 1.0);
        if (insideTheRange) {
            std::cout << "Введенное число в диапазоне от 0.000001 до 1.0\n";
        } else {
            std::cout << "Введенное число не в диапазоне от 0.000001 до 1.0\n";
        }
    } else if (!containsDigitsAndDot(userInput).empty()) {
        double value = convertToDouble(userInput);
        bool insideTheRange = isInRange(value, 0.000001, 1.0);
        if (insideTheRange) {
            std::cout << "Введенное число в диапазоне от 0.000001 до 1.0\n";
        } else {
            std::cout << "Введенное число не в диапазоне от 0.000001 до 1.0\n";
        }
    } else {
        bool stopCommand = compareStrings(userInput, "stop");
        if (!stopCommand) {
            std::cout << "Строка не является числом.\n";
        } else if (stopCommand) {
            std::cout << "Введена команда \"stop\"\n";
        }
    }
}
