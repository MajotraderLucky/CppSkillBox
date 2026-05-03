#include <iostream>
#include <fstream>
#include <string>

// Task 4 — PNG Detector (M19.5 hwork)
// Check that file is PNG: extension .png + magic bytes [-119, 'P', 'N', 'G'].

bool hasPngExtension(const std::string& path) {
    if (path.length() < 4) return false;
    std::string ext = path.substr(path.length() - 4);
    // Lower-case compare for ext
    for (char& c : ext) {
        if (c >= 'A' && c <= 'Z') c = c - 'A' + 'a';
    }
    return ext == ".png";
}

bool hasPngMagic(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f.is_open()) return false;
    char buf[4];
    f.read(buf, 4);
    if (f.gcount() < 4) return false;
    return buf[0] == static_cast<char>(-119) &&
           buf[1] == 'P' &&
           buf[2] == 'N' &&
           buf[3] == 'G';
}

int main(int argc, char* argv[]) {
    std::string path;
    if (argc > 1) {
        path = argv[1];
    } else {
        std::cerr << "Enter file path: ";
        if (!std::getline(std::cin, path)) return 1;
    }

    bool extOk = hasPngExtension(path);
    bool magicOk = hasPngMagic(path);

    if (extOk && magicOk) {
        std::cout << "Valid PNG" << std::endl;
    } else if (!extOk) {
        std::cout << "Not PNG (wrong extension)" << std::endl;
    } else {
        std::cout << "Not PNG (wrong magic bytes)" << std::endl;
    }
    return 0;
}
