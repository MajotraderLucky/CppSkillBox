#include <iostream>
#include <vector>

const int CAPACITY = 20;

int main() {
    std::vector<int> db(CAPACITY);  // фиксированный размер 20, never resize

    int writePos = 0;     // куда писать следующий элемент (mod CAPACITY)
    int totalCount = 0;   // сколько всего добавлено за всё время

    int n;
    while (true) {
        std::cout << "input number: ";
        if (!(std::cin >> n)) break;  // EOF / read failure → exit gracefully

        if (n == -1) {
            // Output: всё содержимое в порядке добавления
            std::cout << "output: ";
            int count = (totalCount < CAPACITY) ? totalCount : CAPACITY;
            int start = (totalCount < CAPACITY) ? 0 : writePos;
            for (int i = 0; i < count; i++) {
                std::cout << db[(start + i) % CAPACITY] << " ";
            }
            std::cout << std::endl;
        } else {
            // Add — pure index assignment, без resize
            db[writePos] = n;
            writePos = (writePos + 1) % CAPACITY;
            totalCount++;
        }
    }

    return 0;
}
