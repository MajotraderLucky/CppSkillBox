#include <iostream>

// Пупырка 12×12. Каждый пузырёк = bool (true = целый, false = лопнутый).
// 3 функции: init, print, popRegion.
// Game loop: пока вся плёнка не лопнута, user вводит регион (x1 y1 x2 y2),
// функция лопает все целые пузыри в этом прямоугольнике.

const int N = 12;

// Init: все целые
void initBubbles(bool shell[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            shell[i][j] = true;
        }
    }
}

// Print: 'o' = целый, 'x' = лопнутый
void printBubbles(bool shell[N][N]) {
    std::cout << "  ";
    for (int j = 0; j < N; j++) std::cout << j % 10 << " ";
    std::cout << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << (i < 10 ? " " : "") << i << " ";
        for (int j = 0; j < N; j++) {
            std::cout << (shell[i][j] ? 'o' : 'x') << " ";
        }
        std::cout << std::endl;
    }
}

// Pop region (x1,y1)-(x2,y2). Возвращает число лопнутых пузырей.
int popRegion(bool shell[N][N], int x1, int y1, int x2, int y2) {
    // Validate: координаты в пределах массива
    if (x1 < 0 || x1 >= N || y1 < 0 || y1 >= N ||
        x2 < 0 || x2 >= N || y2 < 0 || y2 >= N) {
        std::cout << "Error: coordinates out of bounds [0.." << (N - 1) << "]." << std::endl;
        return 0;
    }
    // Normalize: x1,y1 = top-left, x2,y2 = bottom-right
    if (x1 > x2) { int t = x1; x1 = x2; x2 = t; }
    if (y1 > y2) { int t = y1; y1 = y2; y2 = t; }

    int popped = 0;
    for (int i = x1; i <= x2; i++) {
        for (int j = y1; j <= y2; j++) {
            if (shell[i][j]) {   // только целые
                shell[i][j] = false;
                std::cout << "Pop!" << std::endl;
                popped++;
            }
        }
    }
    return popped;
}

// Подсчёт оставшихся целых пузырей
int countIntact(bool shell[N][N]) {
    int count = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (shell[i][j]) count++;
        }
    }
    return count;
}

int main() {
    bool shell[N][N];
    initBubbles(shell);

    std::cout << "=== Bubble Wrap " << N << "x" << N << " ===" << std::endl;
    std::cout << "Enter region as: x1 y1 x2 y2 (0.." << (N - 1) << ")" << std::endl;

    while (countIntact(shell) > 0) {
        printBubbles(shell);
        int x1, y1, x2, y2;
        std::cout << "Region: ";
        if (!(std::cin >> x1 >> y1 >> x2 >> y2)) {
            std::cout << "Input ended." << std::endl;
            break;
        }
        popRegion(shell, x1, y1, x2, y2);
    }

    if (countIntact(shell) == 0) {
        printBubbles(shell);
        std::cout << "All bubbles popped! Game over." << std::endl;
    }

    return 0;
}
