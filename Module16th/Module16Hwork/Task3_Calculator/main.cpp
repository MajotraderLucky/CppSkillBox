#include <iostream>
#include <sstream>
#include <string>

// Task 3 — Калькулятор (M16.6 hwork)
// Парсит строку "<num1><op><num2>" (без пробелов) через stringstream.

int main() {
    std::cerr << "Enter expression (e.g. 3.5+2): ";
    std::string buffer;
    if (!(std::cin >> buffer)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }
    std::stringstream ss(buffer);
    double a, b;
    char op;
    if (!(ss >> a >> op >> b)) {
        std::cout << "Parse error" << std::endl;
        return 1;
    }

    double result;
    switch (op) {
        case '+': result = a + b; break;
        case '-': result = a - b; break;
        case '*': result = a * b; break;
        case '/':
            if (b == 0.0) {
                std::cout << "Division by zero" << std::endl;
                return 1;
            }
            result = a / b;
            break;
        default:
            std::cout << "Unknown operator: " << op << std::endl;
            return 1;
    }
    std::cout << result << std::endl;
    return 0;
}
