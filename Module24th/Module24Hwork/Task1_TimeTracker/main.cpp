// M24.5 Task 1 — Менеджер учёта времени.
// Команды: begin, end, status, exit.

#include <ctime>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Task {
    std::string name;
    std::time_t start;
    std::time_t end;
};

int main(int argc, char** argv) {
    // --time-source=integer N — использовать N как монотонный счётчик секунд
    // (для детерминированных тестов). По умолчанию реальное время.
    bool useFake = false;
    std::time_t fake = 0;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--fake-time") useFake = true;
    }

    auto now = [&]() -> std::time_t {
        return useFake ? ++fake : std::time(nullptr);
    };

    std::vector<Task> finished;
    bool active = false;
    Task current;

    std::string cmd;
    while (std::cin >> cmd) {
        if (cmd == "begin") {
            std::string name;
            std::cin >> name;
            std::time_t t = now();
            if (active) {
                current.end = t;
                finished.push_back(current);
            }
            current = {name, t, 0};
            active = true;
        } else if (cmd == "end") {
            if (active) {
                current.end = now();
                finished.push_back(current);
                active = false;
            }
        } else if (cmd == "status") {
            for (const auto& t : finished) {
                double secs = std::difftime(t.end, t.start);
                std::cout << t.name << ": " << static_cast<long>(secs) << "s\n";
            }
            if (active) {
                std::cout << "active: " << current.name << "\n";
            }
        } else if (cmd == "exit") {
            break;
        } else {
            std::cerr << "Неизвестная команда: " << cmd << "\n";
        }
    }
    return 0;
}
