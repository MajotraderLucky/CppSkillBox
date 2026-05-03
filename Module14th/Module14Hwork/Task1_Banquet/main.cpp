#include <iostream>

// Банкетный стол: 2 ряда × 6 мест = 12 персон.
// VIP места — рядом во главе стола: [0][0] и [1][0]
// (первые места обоих рядов, "напротив" друг друга).

const int ROWS = 2;
const int COLS = 6;

// Печать массива с подписью
void printArray(const char* name, int arr[ROWS][COLS]) {
    std::cout << name << ":" << std::endl;
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            std::cout << arr[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    // Initial state:
    // Cutlery: 3 на каждого (вилка, ложка, нож) + 1 десертная ложка для VIP (=4 у VIP)
    int cutlery[ROWS][COLS] = {
        {4, 3, 3, 3, 3, 3},   // ряд 0: VIP в [0][0]
        {4, 3, 3, 3, 3, 3}    // ряд 1: VIP в [1][0]
    };

    // Plates: 2 на каждого + 1 десертная для VIP (=3 у VIP)
    int plates[ROWS][COLS] = {
        {3, 2, 2, 2, 2, 2},
        {3, 2, 2, 2, 2, 2}
    };

    // Chairs: 1 на каждого
    int chairs[ROWS][COLS] = {
        {1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1}
    };

    std::cout << "=== Initial state ===" << std::endl;
    printArray("Cutlery", cutlery);
    printArray("Plates", plates);
    printArray("Chairs", chairs);

    // Event 1: На 5-е место 1-го ряда дама привела ребёнка → +1 стул
    // 5-е место (1-indexed) = index 4
    chairs[0][4] += 1;

    // Event 2: С 3-го места 2-го ряда украдена ложка → -1 ложка
    // 3-е место (1-indexed) = index 2
    cutlery[1][2] -= 1;

    // Event 3: VIP [0][0] поделилась десертной ложкой с тем, кто остался без ложки [1][2]
    cutlery[0][0] -= 1;   // VIP отдала
    cutlery[1][2] += 1;   // получил тот, у кого украли

    // Event 4: Официант забрал десертную тарелку у VIP [0][0]
    // (VIP теперь ест суп десертной ложкой, тарелка для десерта не нужна)
    plates[0][0] -= 1;

    std::cout << std::endl << "=== After events ===" << std::endl;
    printArray("Cutlery", cutlery);
    printArray("Plates", plates);
    printArray("Chairs", chairs);

    return 0;
}
