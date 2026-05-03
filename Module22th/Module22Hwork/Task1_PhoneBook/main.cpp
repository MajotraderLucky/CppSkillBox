// M22.6 Task 1 — Телефонный справочник.
// Запросы:
//   "<phone> <name>" — добавить
//   "<phone>"        — найти имя по номеру
//   "<name>"         — найти все номера по имени
//
// Сложность: O(log N) для add/lookup-by-phone,
//            O(log N + K) для lookup-by-name (K = #номеров с этой фамилией).

#include <iostream>
#include <map>
#include <string>
#include <vector>

bool looksLikePhone(const std::string& s) {
    if (s.empty()) return false;
    for (char c : s) {
        if (!((c >= '0' && c <= '9') || c == '-')) return false;
    }
    return true;
}

int main() {
    std::map<std::string, std::string>              phoneToName;
    std::map<std::string, std::vector<std::string>> nameToPhones;

    std::string line;
    while (std::getline(std::cin, line)) {
        if (line.empty()) continue;

        // Find space (если есть — это add)
        auto spacePos = line.find(' ');
        if (spacePos != std::string::npos) {
            std::string phone = line.substr(0, spacePos);
            std::string name  = line.substr(spacePos + 1);
            // Удалить старую обратную привязку если phone был занят.
            auto it = phoneToName.find(phone);
            if (it != phoneToName.end()) {
                auto& vec = nameToPhones[it->second];
                for (auto vit = vec.begin(); vit != vec.end(); ++vit) {
                    if (*vit == phone) { vec.erase(vit); break; }
                }
                if (vec.empty()) nameToPhones.erase(it->second);
            }
            phoneToName[phone] = name;
            nameToPhones[name].push_back(phone);
        } else if (looksLikePhone(line)) {
            auto it = phoneToName.find(line);
            if (it != phoneToName.end()) {
                std::cout << it->second << "\n";
            } else {
                std::cout << "not found\n";
            }
        } else {
            // По имени
            auto it = nameToPhones.find(line);
            if (it != nameToPhones.end() && !it->second.empty()) {
                for (size_t i = 0; i < it->second.size(); ++i) {
                    if (i > 0) std::cout << " ";
                    std::cout << it->second[i];
                }
                std::cout << "\n";
            } else {
                std::cout << "not found\n";
            }
        }
    }
    return 0;
}
