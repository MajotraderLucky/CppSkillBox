// M24.5 Task 3 — Таймер.
// Ввод: MM:SS → обратный отсчёт с выводом каждую секунду → DING! DING! DING!

#include <chrono>
#include <cstdio>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <thread>

int main(int argc, char** argv) {
    // --no-sleep ускоряет тесты (без реальной задержки в 1 сек).
    bool noSleep = false;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--no-sleep") noSleep = true;
    }

    std::cerr << "Введите MM:SS: ";
    std::tm t = {};
    std::cin >> std::get_time(&t, "%M:%S");
    if (std::cin.fail()) {
        std::cerr << "Не смог распарсить\n";
        return 1;
    }

    int totalSecs = t.tm_min * 60 + t.tm_sec;
    if (totalSecs <= 0) {
        std::cout << "DING! DING! DING!\n";
        return 0;
    }

    for (int left = totalSecs; left > 0; --left) {
        char buf[16];
        std::snprintf(buf, sizeof(buf), "%02d:%02d", left / 60, left % 60);
        std::cout << buf << "\n";
        if (!noSleep) std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    std::cout << "DING! DING! DING!\n";
    return 0;
}
