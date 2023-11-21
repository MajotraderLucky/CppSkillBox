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

