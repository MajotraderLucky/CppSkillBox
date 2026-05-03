#include <iostream>
#include <vector>

// Task 2 — Two Sum (M15.6 hwork)
// Дан массив целых чисел и target. Найти 2 числа в массиве, сумма которых
// = target. Гарантируется ровно одна пара. Вывести числа.
//
// Алгоритм: O(n²) naive (как в M15.2 с двумя циклами), early-exit
// при первой найденной паре. unordered_map в курсе ещё не проходили.

bool findPair(const std::vector<int>& a, int target, int& x, int& y) {
    for (size_t i = 0; i < a.size(); i++) {
        for (size_t j = i + 1; j < a.size(); j++) {
            if (a[i] + a[j] == target) {
                x = a[i];
                y = a[j];
                return true;  // early-exit: первая удовлетворяющая пара
            }
        }
    }
    return false;
}

int main() {
    int n, target;
    std::cerr << "Enter array size: ";
    if (!(std::cin >> n) || n < 0) {
        std::cerr << "Invalid size" << std::endl;
        return 1;
    }

    std::vector<int> a(n);
    if (n > 0) std::cerr << "Enter " << n << " integers: ";
    for (int i = 0; i < n; i++) {
        if (!(std::cin >> a[i])) {
            std::cerr << "Invalid input" << std::endl;
            return 1;
        }
    }

    std::cerr << "Enter target: ";
    if (!(std::cin >> target)) {
        std::cerr << "Invalid target" << std::endl;
        return 1;
    }

    int x = 0, y = 0;
    if (findPair(a, target, x, y)) {
        std::cout << x << " " << y << std::endl;
    } else {
        std::cout << "No pair found" << std::endl;
    }
    return 0;
}
