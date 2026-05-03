#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

// Task 3 — Ведомость (M19.5 hwork)
// Парсить "Name Surname amount DD.MM.YYYY" построчно. Output: total + max recipient.

int main(int argc, char* argv[]) {
    std::string filepath = "vedomost.txt";
    if (argc > 1) filepath = argv[1];

    std::ifstream f(filepath);
    if (!f.is_open()) {
        std::cerr << "Error: cannot open " << filepath << std::endl;
        return 1;
    }

    long long total = 0;
    long long max_amount = -1;
    std::string max_name;

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty()) continue;
        std::stringstream ss(line);
        std::string firstName, lastName, date;
        long long amount;
        if (!(ss >> firstName >> lastName >> amount >> date)) {
            std::cerr << "Parse error: '" << line << "'" << std::endl;
            continue;
        }
        total += amount;
        if (amount > max_amount) {
            max_amount = amount;
            max_name = firstName + " " + lastName;
        }
    }

    std::cout << "Total: " << total << std::endl;
    std::cout << "Max recipient: " << max_name << " (" << max_amount << ")" << std::endl;
    return 0;
}
