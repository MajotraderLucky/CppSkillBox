// M24.5 Task 2 — Напоминание о днях рождения.
// Ввод: <name> <YYYY/MM/DD>, конец = name "end"
// Вывод: ближайший DR в формате MM/DD + имя.
// Если DR сегодня → спец. сообщение (может быть несколько).
// Если DR уже был в этом году — пропускается.

#include <climits>
#include <cstdio>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct Friend {
    std::string name;
    int month;   // 1-12
    int day;     // 1-31
};

bool parseDate(const std::string& s, int& y, int& m, int& d) {
    char sep1, sep2;
    std::istringstream is(s);
    if (!(is >> y >> sep1 >> m >> sep2 >> d)) return false;
    if (sep1 != '/' || sep2 != '/') return false;
    if (m < 1 || m > 12 || d < 1 || d > 31) return false;
    return true;
}

// Вернёт количество дней от (todayMonth, todayDay) до (birthMonth, birthDay).
// Если уже прошло → -1 (вызывающий пропустит).
int daysUntil(int todayMonth, int todayDay, int birthMonth, int birthDay) {
    if (birthMonth < todayMonth) return -1;
    if (birthMonth == todayMonth && birthDay < todayDay) return -1;
    return (birthMonth - todayMonth) * 31 + (birthDay - todayDay);
    // Грубое приближение, но достаточно для сравнения порядка
}

int main(int argc, char** argv) {
    // --today=MM:DD — для тестов фиксируем "сегодня".
    int todayMonth = 0, todayDay = 0;
    bool fixedToday = false;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--today=", 0) == 0) {
            sscanf(a.c_str() + 8, "%d:%d", &todayMonth, &todayDay);
            fixedToday = true;
        }
    }
    if (!fixedToday) {
        std::time_t t = std::time(nullptr);
        std::tm* lt = std::localtime(&t);
        todayMonth = lt->tm_mon + 1;
        todayDay   = lt->tm_mday;
    }

    std::vector<Friend> friends;
    std::string name;
    while (std::cin >> name) {
        if (name == "end") break;
        std::string dateStr;
        if (!(std::cin >> dateStr)) break;
        int y, m, d;
        if (!parseDate(dateStr, y, m, d)) {
            std::cerr << "Bad date: " << dateStr << "\n";
            continue;
        }
        friends.push_back({name, m, d});
    }

    // Найти все с DR сегодня
    bool anyToday = false;
    for (const auto& f : friends) {
        if (f.month == todayMonth && f.day == todayDay) {
            std::cout << "Сегодня день рождения у " << f.name << "!\n";
            anyToday = true;
        }
    }

    // Найти ближайший в будущем (исключая сегодня)
    int bestDays = INT_MAX;
    const Friend* best = nullptr;
    for (const auto& f : friends) {
        if (f.month == todayMonth && f.day == todayDay) continue;
        int days = daysUntil(todayMonth, todayDay, f.month, f.day);
        if (days < 0) continue;
        if (days < bestDays) {
            bestDays = days;
            best = &f;
        }
    }

    if (best) {
        char buf[16];
        std::snprintf(buf, sizeof(buf), "%02d/%02d", best->month, best->day);
        std::cout << "Ближайший: " << best->name << " " << buf << "\n";
    } else if (!anyToday) {
        std::cout << "Нет ближайших дней рождения\n";
    }
    return 0;
}
