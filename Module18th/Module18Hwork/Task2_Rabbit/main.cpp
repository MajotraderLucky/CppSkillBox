#include <iostream>

// Task 2 — Rabbit on staircase (M18.5 hwork)
// Recursive count of ways to reach n-th step, jumps 1..k.
// Default k = 3.

int rabbit(int n, int k = 3) {
    if (n == 0) return 1;        // достигли цели
    if (n < 0) return 0;          // переехали
    int total = 0;
    for (int i = 1; i <= k; i++) {
        total += rabbit(n - i, k);
    }
    return total;
}

int main() {
    int n, k;
    std::cerr << "Enter n: ";
    if (!(std::cin >> n)) {
        std::cerr << "Invalid n" << std::endl;
        return 1;
    }
    std::cerr << "Enter k (or -1 for default 3): ";
    if (!(std::cin >> k)) {
        std::cerr << "Invalid k" << std::endl;
        return 1;
    }
    if (k < 0) {
        std::cout << rabbit(n) << std::endl;       // use default k=3
    } else {
        std::cout << rabbit(n, k) << std::endl;
    }
    return 0;
}
