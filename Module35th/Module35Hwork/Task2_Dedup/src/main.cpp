// M35.6 Task 2 — lambda + unordered_set + unique_ptr<vector<int>> для удаления дубликатов.
//
// Reads ints from stdin, dedupes, prints to stdout (preserving first-occurrence order).
// CLI:
//   ./dedup                    — interactive
//   ./dedup --input="1 2 1 3"  — one-shot для тестов

#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

int main(int argc, char** argv) {
    auto dedup = [](const std::vector<int>& src) -> std::unique_ptr<std::vector<int>> {
        auto result = std::make_unique<std::vector<int>>();
        std::unordered_set<int> seen;
        for (auto v : src) {
            if (seen.count(v) == 0) {
                seen.insert(v);
                result->push_back(v);
            }
        }
        return result;
    };

    std::vector<int> input;
    std::string inlineSrc;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--input=", 0) == 0) inlineSrc = a.substr(8);
    }
    if (!inlineSrc.empty()) {
        std::istringstream iss(inlineSrc);
        int n;
        while (iss >> n) input.push_back(n);
    } else {
        int n;
        while (std::cin >> n) input.push_back(n);
    }

    auto out = dedup(input);
    bool first = true;
    for (auto n : *out) {
        if (!first) std::cout << ' ';
        std::cout << n;
        first = false;
    }
    std::cout << std::endl;
    return 0;
}
