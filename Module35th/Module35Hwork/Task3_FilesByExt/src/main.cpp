// M35.6 Task 3 — lambda + std::filesystem::recursive_directory_iterator.
// Поиск файлов по расширению.
//
// CLI:
//   ./files_by_ext <path> <ext>
//   ./files_by_ext /tmp .txt

#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

namespace fs = std::filesystem;

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <path> <extension>" << std::endl;
        std::cerr << "Example: " << argv[0] << " /tmp .txt" << std::endl;
        return 1;
    }

    auto recursiveGetFileNamesByExtension =
        [](fs::path path, const std::string extension) {
            std::vector<std::string> result;
            if (!fs::exists(path) || !fs::is_directory(path)) return result;
            for (auto& p : fs::recursive_directory_iterator(path)) {
                if (p.is_regular_file() &&
                    p.path().extension().compare(extension) == 0) {
                    result.push_back(p.path().filename().string());
                }
            }
            return result;
        };

    auto files = recursiveGetFileNamesByExtension(argv[1], argv[2]);
    for (const auto& name : files) {
        std::cout << name << std::endl;
    }
    return 0;
}
