#include <iostream>
#include <fstream>
#include <string>

// Task 3 — Fishing simulation (M20.5)
// river.txt — рыба per line. User вводит вид → проходим, при совпадении append в basket.txt.

int main(int argc, char* argv[]) {
    std::string riverPath = "river.txt";
    std::string basketPath = "basket.txt";
    if (argc > 1) riverPath = argv[1];
    if (argc > 2) basketPath = argv[2];

    std::cerr << "Target fish: ";
    std::string target;
    if (!(std::cin >> target)) return 1;

    std::ifstream river(riverPath);
    if (!river.is_open()) {
        std::cerr << "Cannot open river " << riverPath << std::endl;
        return 1;
    }
    std::ofstream basket(basketPath, std::ios::app);
    if (!basket.is_open()) {
        std::cerr << "Cannot open basket " << basketPath << std::endl;
        return 1;
    }

    int caught = 0;
    std::string fish;
    while (river >> fish) {
        if (fish == target) {
            basket << fish << "\n";
            caught++;
        }
    }
    std::cout << "Caught " << caught << " " << target << std::endl;
    return 0;
}
