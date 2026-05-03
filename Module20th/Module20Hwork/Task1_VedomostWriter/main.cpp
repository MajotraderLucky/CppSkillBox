#include <iostream>
#include <fstream>
#include <string>

// Task 1 — Запись в ведомость (M20.5)
// Append: "Name Surname DD.MM.YYYY amount\n". Валидация даты.

bool validDate(const std::string& d) {
    // Format D[D].M[M].YYYY — flexible (1.1.2021 or 11.11.2021)
    size_t p1 = d.find('.');
    if (p1 == std::string::npos) return false;
    size_t p2 = d.find('.', p1 + 1);
    if (p2 == std::string::npos) return false;
    if (d.find('.', p2 + 1) != std::string::npos) return false;
    try {
        int day = std::stoi(d.substr(0, p1));
        int month = std::stoi(d.substr(p1 + 1, p2 - p1 - 1));
        int year = std::stoi(d.substr(p2 + 1));
        if (day < 1 || day > 31) return false;
        if (month < 1 || month > 12) return false;
        if (year < 1900 || year > 2100) return false;
    } catch (...) { return false; }
    return true;
}

int main(int argc, char* argv[]) {
    std::string filepath = "vedomost.txt";
    if (argc > 1) filepath = argv[1];

    std::cerr << "Name: ";
    std::string name;
    if (!(std::cin >> name)) return 1;
    std::cerr << "Surname: ";
    std::string surname;
    if (!(std::cin >> surname)) return 1;
    std::cerr << "Date (DD.MM.YYYY): ";
    std::string date;
    if (!(std::cin >> date)) return 1;
    if (!validDate(date)) {
        std::cout << "Invalid date" << std::endl;
        return 1;
    }
    std::cerr << "Amount: ";
    long long amount;
    if (!(std::cin >> amount) || amount <= 0) {
        std::cout << "Invalid amount" << std::endl;
        return 1;
    }

    std::ofstream f(filepath, std::ios::app);
    if (!f.is_open()) {
        std::cerr << "Cannot open " << filepath << std::endl;
        return 1;
    }
    f << name << " " << surname << " " << date << " " << amount << "\n";
    std::cout << "OK" << std::endl;
    return 0;
}
