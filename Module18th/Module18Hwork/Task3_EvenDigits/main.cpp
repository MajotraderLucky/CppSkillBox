#include <iostream>

// Task 3 — evendigits (M18.5 hwork)
// Recursive count of even digits в long long n. Result в ans (by ref).

void evendigits(long long n, int& ans) {
    if (n < 0) n = -n;          // нормализация для negative
    if (n == 0) return;          // base case (0 — это сам по себе чётная цифра, но
                                  // если n=0 в самом начале — пустая запись имеет 0 even digits;
                                  // если n стало 0 после отбрасывания цифр — стоп)
    int digit = n % 10;
    if (digit % 2 == 0) ans++;
    evendigits(n / 10, ans);
}

int main() {
    long long n;
    std::cerr << "Enter long long n: ";
    if (!(std::cin >> n)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }
    int ans = 0;
    // Edge case: n == 0 → 1 even digit ('0')
    if (n == 0) ans = 1;
    else evendigits(n, ans);
    std::cout << ans << std::endl;
    return 0;
}
