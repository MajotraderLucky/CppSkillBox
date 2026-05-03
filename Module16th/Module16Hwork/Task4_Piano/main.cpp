#include <iostream>
#include <string>

// Task 4 — Механическое пианино (M16.6 hwork)
// Bit mask enum для 7 нот. Ввод: строка цифр 1-7. Дубли игнорируются.

enum note {
    DO  = 1,    // 1 << 0
    RE  = 2,    // 1 << 1
    MI  = 4,    // 1 << 2
    FA  = 8,    // 1 << 3
    SOL = 16,   // 1 << 4
    LA  = 32,   // 1 << 5
    SI  = 64    // 1 << 6
};

int main() {
    std::cerr << "Enter chord (digits 1-7, e.g. 1234 or 63): ";
    std::string chord;
    if (!(std::cin >> chord)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }

    int notes = 0;
    for (size_t i = 0; i < chord.length(); i++) {
        char c = chord[i];
        if (c < '1' || c > '7') {
            std::cout << "Invalid note: " << c << std::endl;
            return 1;
        }
        int idx = c - '1';        // 0..6
        notes |= (1 << idx);      // включаем бит — дубли становятся одним битом
    }

    bool first = true;
    auto emit = [&](const char* name) {
        if (!first) std::cout << " ";
        std::cout << name;
        first = false;
    };

    if (notes & DO)  emit("DO");
    if (notes & RE)  emit("RE");
    if (notes & MI)  emit("MI");
    if (notes & FA)  emit("FA");
    if (notes & SOL) emit("SOL");
    if (notes & LA)  emit("LA");
    if (notes & SI)  emit("SI");
    std::cout << std::endl;
    return 0;
}
