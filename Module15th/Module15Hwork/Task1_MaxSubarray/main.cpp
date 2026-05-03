#include <iostream>
#include <vector>

// Task 1 — Maximum Subarray (M15.6 hwork)
// Дан массив целых чисел. Найти индексы i, j такие, что сумма
// a[i] + a[i+1] + ... + a[j] максимальна. Вывести i и j.
//
// Алгоритм: Kadane's algorithm — O(n) single-pass с tracking
// «текущей суммы» и «глобального максимума» (как M15.3 «min_v» паттерн).

void solve(const std::vector<int>& a) {
    if (a.empty()) {
        std::cout << "Empty array" << std::endl;
        return;
    }

    // Kadane: на каждом шаге решаем — продолжать текущий подмассив или начать новый.
    int cur_sum = a[0];
    int cur_start = 0;
    int best_sum = a[0];
    int best_i = 0;
    int best_j = 0;

    for (size_t k = 1; k < a.size(); k++) {
        if (cur_sum + a[k] < a[k]) {
            // Начать новый подмассив с k (предыдущая сумма «тянет вниз»)
            cur_sum = a[k];
            cur_start = static_cast<int>(k);
        } else {
            cur_sum += a[k];
        }

        if (cur_sum > best_sum) {
            best_sum = cur_sum;
            best_i = cur_start;
            best_j = static_cast<int>(k);
        }
    }

    std::cout << best_i << " " << best_j << std::endl;
}

int main() {
    int n;
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

    solve(a);
    return 0;
}
