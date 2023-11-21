#include "usersinputcontrol.hpp"
#include <cctype> // for isdigit() function

bool isDigitsOnly(const std::string& input) {
    for (char c : input) {
        if (!std::isdigit(c)) {
            return false;
        }
    }
    return true;
}

std::string containsDigitsAndDot(const std::string& input) {
    bool hasOneDot = false;
    
    // проверка на наличие точки в начале и в конце строки
    if (input.front() == '.' || input.back() == '.') {
        return "";
    }

    for (char c : input) {
        if (std::isdigit(c)) {
            continue;
        } else if (c == '.' && !hasOneDot) {
            hasOneDot = true;
        } else {
            return "";
        }
    }
    
    if (hasOneDot)
        return input;

    return "";  // Возвращаем пустую строку, если в строке нет точки
}

