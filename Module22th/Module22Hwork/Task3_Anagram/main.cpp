// M22.6 Task 3 — Анаграммы.
// bool isAnagram(a, b) — true если строки содержат одинаковый набор символов.
// Реализация через map<char, int> — частоты символов.

#include <iostream>
#include <map>
#include <string>

bool isAnagram(const std::string& a, const std::string& b) {
    if (a.size() != b.size()) return false;
    std::map<char, int> ca, cb;
    for (char c : a) ++ca[c];
    for (char c : b) ++cb[c];
    return ca == cb;
}

int main() {
    std::string a, b;
    std::cerr << "Строка 1: ";
    if (!(std::cin >> a)) return 1;
    std::cerr << "Строка 2: ";
    if (!(std::cin >> b)) return 1;
    std::cout << (isAnagram(a, b) ? "true" : "false") << "\n";
    return 0;
}
