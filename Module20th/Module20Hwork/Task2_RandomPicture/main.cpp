#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>

// Task 2 — Random binary picture (M20.5)
// Read W H, generate W×H matrix 0/1 → pic.txt

int main(int argc, char* argv[]) {
    std::string filepath = "pic.txt";
    int seed = 0;  // 0 = use time, else fixed
    if (argc > 1) filepath = argv[1];
    if (argc > 2) seed = std::atoi(argv[2]);

    int w, h;
    std::cerr << "Width: ";
    if (!(std::cin >> w) || w <= 0) {
        std::cerr << "Invalid width" << std::endl;
        return 1;
    }
    std::cerr << "Height: ";
    if (!(std::cin >> h) || h <= 0) {
        std::cerr << "Invalid height" << std::endl;
        return 1;
    }

    if (seed == 0) std::srand(std::time(nullptr));
    else std::srand(seed);

    std::ofstream f(filepath);
    if (!f.is_open()) {
        std::cerr << "Cannot open " << filepath << std::endl;
        return 1;
    }
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            f << (std::rand() % 2);
        }
        f << "\n";
    }
    std::cout << "OK " << w << "x" << h << std::endl;
    return 0;
}
