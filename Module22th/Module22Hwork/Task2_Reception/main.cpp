// M22.6 Task 2 — Регистратура.
// Очередь пациентов, запросы:
//   <фамилия> — встать в очередь
//   Next      — вызвать первого по лексикографическому порядку, вывести и удалить
//
// Сложность каждой операции: O(log N).
// Реализация: map<surname, count> — отсортированные ключи + дубликаты как count.

#include <iostream>
#include <map>
#include <string>

int main() {
    std::map<std::string, int> queue;

    std::string line;
    while (std::cin >> line) {
        if (line == "Next") {
            if (queue.empty()) continue;
            auto it = queue.begin();             // лексикографический минимум
            std::cout << it->first << "\n";
            if (--(it->second) == 0) queue.erase(it);
        } else {
            ++queue[line];
        }
    }
    return 0;
}
