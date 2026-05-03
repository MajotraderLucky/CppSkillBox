#include <iostream>
#include <fstream>
#include <string>

// Task 2 — Text Viewer (M19.5 hwork)
// Path → stdout. Read by chunks (gcount), is_open() validation.

const int CHUNK = 4096;

int main(int argc, char* argv[]) {
    std::string filepath;
    if (argc > 1) {
        filepath = argv[1];
    } else {
        std::cerr << "Enter file path: ";
        if (!std::getline(std::cin, filepath)) return 1;
    }

    std::ifstream f(filepath, std::ios::binary);
    if (!f.is_open()) {
        std::cerr << "Error: cannot open " << filepath << std::endl;
        return 1;
    }

    char buffer[CHUNK];
    while (f.read(buffer, CHUNK) || f.gcount() > 0) {
        std::cout.write(buffer, f.gcount());
    }
    return 0;
}
