// M21.5 Task 1 — Ведомость учёта со структурами.
// Команды: list (вывести записи), add (добавить запись).

#include <fstream>
#include <iostream>
#include <string>
#include <vector>

struct VedomostEntry {
    std::string fullName;   // "Имя Фамилия"
    std::string date;       // "ДД.ММ.ГГГГ"
    int amount = 0;         // сумма в рублях
};

constexpr const char* DEFAULT_FILE = "vedomost.txt";

bool isValidDate(const std::string& d) {
    auto dot1 = d.find('.');
    if (dot1 == std::string::npos) return false;
    auto dot2 = d.find('.', dot1 + 1);
    if (dot2 == std::string::npos) return false;
    if (d.find('.', dot2 + 1) != std::string::npos) return false;

    std::string ds = d.substr(0, dot1);
    std::string ms = d.substr(dot1 + 1, dot2 - dot1 - 1);
    std::string ys = d.substr(dot2 + 1);
    if (ds.empty() || ms.empty() || ys.empty()) return false;
    if (ys.size() != 4) return false;

    try {
        int day   = std::stoi(ds);
        int month = std::stoi(ms);
        int year  = std::stoi(ys);
        if (day < 1 || day > 31)     return false;
        if (month < 1 || month > 12) return false;
        if (year < 1900)             return false;
    } catch (...) { return false; }
    return true;
}

std::vector<VedomostEntry> loadAll(const std::string& path) {
    std::vector<VedomostEntry> entries;
    std::ifstream f(path);
    if (!f.is_open()) return entries;

    while (true) {
        VedomostEntry e;
        std::string firstName, lastName;
        f >> firstName;
        if (f.eof()) break;
        f >> lastName >> e.date >> e.amount;
        if (f.fail()) break;
        e.fullName = firstName + " " + lastName;
        entries.push_back(e);
    }
    return entries;
}

void cmdList(const std::string& path) {
    auto entries = loadAll(path);
    if (entries.empty()) {
        std::cout << "(empty)\n";
        return;
    }
    for (const auto& e : entries) {
        std::cout << e.fullName << " " << e.date << " " << e.amount << "\n";
    }
}

bool cmdAdd(const std::string& path) {
    VedomostEntry e;
    std::string firstName, lastName;

    std::cerr << "Имя: ";
    if (!(std::cin >> firstName)) return false;
    std::cerr << "Фамилия: ";
    if (!(std::cin >> lastName)) return false;
    e.fullName = firstName + " " + lastName;

    std::cerr << "Дата (Д.М.ГГГГ): ";
    if (!(std::cin >> e.date)) return false;
    if (!isValidDate(e.date)) {
        std::cerr << "Некорректная дата\n";
        return false;
    }

    std::cerr << "Сумма: ";
    if (!(std::cin >> e.amount)) return false;
    if (e.amount < 0) {
        std::cerr << "Сумма не может быть отрицательной\n";
        return false;
    }

    std::ofstream f(path, std::ios::app);
    if (!f.is_open()) return false;
    f << e.fullName << " " << e.date << " " << e.amount << "\n";
    return true;
}

int main(int argc, char** argv) {
    std::string path = (argc >= 2) ? argv[1] : DEFAULT_FILE;

    std::string cmd;
    std::cerr << "Команда (list/add): ";
    if (!(std::cin >> cmd)) return 1;

    if (cmd == "list") {
        cmdList(path);
    } else if (cmd == "add") {
        if (cmdAdd(path)) {
            std::cout << "OK\n";
        } else {
            std::cout << "FAIL\n";
            return 2;
        }
    } else {
        std::cerr << "Неизвестная команда\n";
        return 1;
    }
    return 0;
}
