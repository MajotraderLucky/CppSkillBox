#include <iostream>
#include <cstring>

// Task 3 — substr (M17.4 hwork)
// bool substr(const char* a, const char* b)
// Возвращает true если b является подстрокой a.

bool substr(const char* a, const char* b) {
    size_t lenA = std::strlen(a);
    size_t lenB = std::strlen(b);

    // Пустая b всегда подстрока
    if (lenB == 0) return true;
    // b длиннее a — невозможно
    if (lenB > lenA) return false;

    // Naive поиск: для каждого стартового offset в a проверяем совпадение
    for (size_t i = 0; i + lenB <= lenA; i++) {
        bool match = true;
        for (size_t j = 0; j < lenB; j++) {
            if (*(a + i + j) != *(b + j)) {
                match = false;
                break;
            }
        }
        if (match) return true;
    }
    return false;
}

int main() {
    std::string a, b;
    std::cerr << "Enter haystack and needle (quoted if spaces; use 2 separate lines): ";
    if (!std::getline(std::cin, a) || !std::getline(std::cin, b)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }
    std::cout << (substr(a.c_str(), b.c_str()) ? "true" : "false") << std::endl;
    return 0;
}
