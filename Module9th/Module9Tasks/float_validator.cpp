#include <iostream>
#include <string>

bool isValidFloat(const std::string& str) {
    if (str.empty()) return false;
    
    int i = 0;
    int n = str.length();
    bool hasDigit = false;
    bool hasDot = false;
    
    // Проверяем первый символ: цифра, точка или минус
    if (str[0] == '-') {
        i = 1;
        if (i >= n) return false; // только минус - некорректно
    }
    
    // Проверяем остальные символы
    while (i < n) {
        char c = str[i];
        
        if (c >= '0' && c <= '9') {
            hasDigit = true;
        } else if (c == '.') {
            if (hasDot) return false; // две точки - некорректно
            hasDot = true;
        } else {
            return false; // недопустимый символ
        }
        i++;
    }
    
    // Должна быть хотя бы одна цифра
    return hasDigit;
}

int main() {
    std::string input;
    std::cout << "Введите число: ";
    std::cin >> input;
    
    if (isValidFloat(input)) {
        std::cout << "Yes" << std::endl;
    } else {
        std::cout << "No" << std::endl;
    }
    
    return 0;
}