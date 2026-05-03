#include <iostream>
#include <vector>

// Task 1 — swapvec (M18.5 hwork)
// Меняет значения vector<int>& a и int* b (одинакового размера).

void swapvec(std::vector<int>& a, int* b) {
    for (size_t i = 0; i < a.size(); i++) {
        int temp = a[i];
        a[i] = b[i];
        b[i] = temp;
    }
}

int main() {
    int n;
    std::cerr << "Enter array size: ";
    if (!(std::cin >> n) || n <= 0) {
        std::cerr << "Invalid size" << std::endl;
        return 1;
    }
    std::vector<int> a(n);
    std::vector<int> b_storage(n);
    int* b = b_storage.data();
    std::cerr << "Enter " << n << " ints for vector a: ";
    for (int i = 0; i < n; i++) std::cin >> a[i];
    std::cerr << "Enter " << n << " ints for array b: ";
    for (int i = 0; i < n; i++) std::cin >> b[i];

    swapvec(a, b);

    for (int i = 0; i < n; i++) {
        if (i > 0) std::cout << " ";
        std::cout << a[i];
    }
    std::cout << std::endl;
    for (int i = 0; i < n; i++) {
        if (i > 0) std::cout << " ";
        std::cout << b[i];
    }
    std::cout << std::endl;
    return 0;
}
