#include <iostream>

// Task 1 — swap через указатели (M17.4 hwork)
// void swap(int* a, int* b) меняет значения по указателям.

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int a, b;
    std::cerr << "Enter two integers: ";
    if (!(std::cin >> a >> b)) {
        std::cerr << "Invalid input" << std::endl;
        return 1;
    }
    swap(&a, &b);
    std::cout << a << " " << b << std::endl;
    return 0;
}
