#include <iostream>

// Task 2 — Reverse 10 ints in-place (M17.4 hwork)
// void reverseTen(int* arr) разворачивает 10 элементов по указателю.

const int N = 10;

void reverseTen(int* arr) {
    // Two-pointer swap: arr[i] ↔ arr[N-1-i] для i от 0 до N/2
    for (int i = 0; i < N / 2; i++) {
        int temp = *(arr + i);
        *(arr + i) = *(arr + N - 1 - i);
        *(arr + N - 1 - i) = temp;
    }
}

int main() {
    int arr[N];
    std::cerr << "Enter 10 integers: ";
    for (int i = 0; i < N; i++) {
        if (!(std::cin >> arr[i])) {
            std::cerr << "Invalid input" << std::endl;
            return 1;
        }
    }
    reverseTen(arr);
    for (int i = 0; i < N; i++) {
        if (i > 0) std::cout << " ";
        std::cout << arr[i];
    }
    std::cout << std::endl;
    return 0;
}
