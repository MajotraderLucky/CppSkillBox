#include <iostream>
#include <vector>
#include <cstdlib>  // std::abs

// Task 4 — Sort by absolute value (M15.6 hwork)
// Дан массив целых чисел отсортированный по возрастанию. Вывести в порядке
// возрастания МОДУЛЯ. Не использовать новую сортировку — массив уже отсортирован.
//
// Алгоритм: two-pointer / merge pattern. O(n) time, O(1) extra memory.
// Идея: найти первый положительный элемент (граница). Двигаться двумя
// указателями: left ← (negative side, абс. значения растут влево),
// right → (positive side). На каждом шаге выводить меньший по abs.

void absSort(const std::vector<int>& a) {
    if (a.empty()) {
        std::cout << "Empty array" << std::endl;
        return;
    }

    // Найти первый non-negative индекс (граница)
    int n = static_cast<int>(a.size());
    int right = 0;
    while (right < n && a[right] < 0) right++;
    int left = right - 1;  // последний negative (-1 если negative нет)

    bool first = true;
    while (left >= 0 || right < n) {
        int chosen;
        if (left < 0) {
            chosen = a[right++];
        } else if (right >= n) {
            chosen = a[left--];
        } else if (std::abs(a[left]) < std::abs(a[right])) {
            chosen = a[left--];
        } else {
            // ties: positive (right) wins — соответствует подсказке «от первого положительного»
            chosen = a[right++];
        }

        if (first) {
            first = false;
        } else {
            std::cout << " ";
        }
        std::cout << chosen;
    }
    std::cout << std::endl;
}

// Проверить что входной массив монотонно неубывающий
bool isSortedAsc(const std::vector<int>& a) {
    for (size_t i = 1; i < a.size(); i++) {
        if (a[i] < a[i - 1]) return false;
    }
    return true;
}

int main() {
    int n;
    std::cerr << "Enter array size: ";
    if (!(std::cin >> n) || n < 0) {
        std::cerr << "Invalid size" << std::endl;
        return 1;
    }

    std::vector<int> a(n);
    if (n > 0) std::cerr << "Enter " << n << " sorted (asc) integers: ";
    for (int i = 0; i < n; i++) {
        if (!(std::cin >> a[i])) {
            std::cerr << "Invalid input" << std::endl;
            return 1;
        }
    }

    if (!isSortedAsc(a)) {
        std::cout << "Input not sorted ascending" << std::endl;
        return 1;
    }

    absSort(a);
    return 0;
}
