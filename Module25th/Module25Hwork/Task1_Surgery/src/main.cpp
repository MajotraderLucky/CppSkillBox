#include "tools.h"

#include <iostream>
#include <string>

int main() {
    bool started = false;
    std::string cmd;
    Point2D a, b;

    std::cerr << "Surgery sim. Команды: scalpel/hemostat/tweezers/suture/exit\n";

    while (std::cin >> cmd) {
        if (cmd == "exit") {
            std::cout << "EXIT\n";
            return 0;
        } else if (cmd == "scalpel") {
            if (!readPoint(a) || !readPoint(b)) return 1;
            if (!started) {
                started = true;
                scalpel(a, b);
            } else {
                std::cerr << "scalpel ignored: операция уже идёт\n";
            }
        } else if (cmd == "hemostat") {
            if (!readPoint(a)) return 1;
            if (started) hemostat(a);
            else std::cerr << "Сначала scalpel\n";
        } else if (cmd == "tweezers") {
            if (!readPoint(a)) return 1;
            if (started) tweezers(a);
            else std::cerr << "Сначала scalpel\n";
        } else if (cmd == "suture") {
            if (!readPoint(a) || !readPoint(b)) return 1;
            if (!started) {
                std::cerr << "Сначала scalpel\n";
                continue;
            }
            suture(a, b);
            if (equalPoints(a, b)) {
                std::cout << "OPERATION COMPLETE\n";
                return 0;
            }
        } else {
            std::cerr << "Неизвестная команда: " << cmd << "\n";
        }
    }
    return 0;
}
