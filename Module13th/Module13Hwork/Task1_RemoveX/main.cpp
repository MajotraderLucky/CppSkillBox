#include <iostream>
#include <vector>

int main() {
    std::cout << "Input vector size: ";
    int n;
    std::cin >> n;

    if (n < 0) {
        std::cout << "Error: size must be non-negative" << std::endl;
        return 1;
    }

    std::vector<int> vec(n);
    std::cout << "Input numbers: ";
    for (int i = 0; i < n; i++) {
        std::cin >> vec[i];
    }

    std::cout << "Input number to delete: ";
    int x;
    std::cin >> x;

    // Two-pointer in-place compaction: shift "хорошие" элементы влево
    int writePos = 0;
    for (int readPos = 0; readPos < (int)vec.size(); readPos++) {
        if (vec[readPos] != x) {
            vec[writePos++] = vec[readPos];
        }
    }

    // Trim tail через pop_back до writePos (по требованию задачи)
    while ((int)vec.size() > writePos) {
        vec.pop_back();
    }

    // Output
    std::cout << "Result: ";
    for (int v : vec) {
        std::cout << v << " ";
    }
    std::cout << std::endl;

    return 0;
}
