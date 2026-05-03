#include <iostream>
#include <fstream>
#include <string>

// Task 1 — Word Search (M19.5 hwork)
// Открыть words.txt, считать слова, посчитать число вхождений запрашиваемого слова.

int main(int argc, char* argv[]) {
    std::string filepath = "words.txt";
    if (argc > 1) filepath = argv[1];

    std::ifstream f(filepath);
    if (!f.is_open()) {
        std::cerr << "Error: cannot open " << filepath << std::endl;
        return 1;
    }

    std::cerr << "Search word: ";
    std::string target;
    if (!(std::cin >> target)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }

    int count = 0;
    std::string word;
    while (f >> word) {
        if (word == target) count++;
    }
    std::cout << count << std::endl;
    return 0;
}
