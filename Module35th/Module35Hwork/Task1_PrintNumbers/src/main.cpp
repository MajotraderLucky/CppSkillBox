// M35.6 Task 1 — print 1..5 via range-based for + auto + initializer_list.

#include <initializer_list>
#include <iostream>

int main() {
    for (auto n : {1, 2, 3, 4, 5}) {
        std::cout << n << std::endl;
    }
    return 0;
}
