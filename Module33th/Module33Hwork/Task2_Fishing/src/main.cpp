// M33.5 Task 2 — Fishing game (9 секторов, 1 рыба + 3 сапога).
// Используем исключения: бросаем Fish* на успехе, Boot* на провале.
//
// Запуск:
//   ./fishing                  — интерактивно: ввод сектора (1..9) пока не поймаем что-то
//   ./fishing --seed=N         — детерминированный seed для тестов
//   ./fishing --seed=N --auto  — авто: пробует все 9 секторов по порядку

#include <cstdlib>
#include <ctime>
#include <iostream>
#include <sstream>
#include <string>

class Fish {};
class Boot {};

struct Sector {
    Fish* fish = nullptr;
    Boot* boot = nullptr;
};

int main(int argc, char** argv) {
    unsigned seed = static_cast<unsigned>(std::time(nullptr));
    bool autoMode = false;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--seed=", 0) == 0) seed = static_cast<unsigned>(std::stoul(a.substr(7)));
        else if (a == "--auto") autoMode = true;
    }
    std::srand(seed);

    Sector field[9];

    // Положить рыбу
    field[std::rand() % 9].fish = new Fish();

    // Положить три сапога — не пересекаются с рыбой и друг с другом
    int placed = 0;
    while (placed < 3) {
        int idx = std::rand() % 9;
        if (field[idx].fish || field[idx].boot) continue;
        field[idx].boot = new Boot();
        ++placed;
    }

    std::cerr << "Cast your line into a sector (1..9):" << std::endl;

    int attempts = 0;
    int autoIdx  = 0;
    try {
        while (true) {
            int sector;
            if (autoMode) {
                if (autoIdx >= 9) break;
                sector = autoIdx + 1;
                ++autoIdx;
                std::cerr << "[auto] sector " << sector << std::endl;
            } else {
                if (!(std::cin >> sector)) break;
            }
            if (sector < 1 || sector > 9) {
                std::cout << "Sector out of range" << std::endl;
                continue;
            }
            ++attempts;
            Sector& s = field[sector - 1];
            if (s.fish) throw s.fish;
            if (s.boot) throw s.boot;
            std::cout << "Empty, try again" << std::endl;
        }
    } catch (Fish*) {
        std::cout << "Caught a fish! attempts=" << attempts << std::endl;
    } catch (Boot*) {
        std::cout << "Caught a boot. Game over after attempts=" << attempts << std::endl;
    }

    // cleanup
    for (auto& s : field) {
        delete s.fish;
        delete s.boot;
    }
    return 0;
}
