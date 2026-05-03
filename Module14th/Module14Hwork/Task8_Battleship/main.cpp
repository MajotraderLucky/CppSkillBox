#include <iostream>

// Морской бой — упрощённая версия по разбору учителя M15.1.
//
// Поле 10×10 (bool), 2 игрока. Корабли: 4×1cell, 3×2cell, 2×3cell, 1×4cell = 10 ship/20 палуб.
// Корабли только горизонтально/вертикально (не диагональ, не квадрат).
//
// Phase 1: расстановка (по очереди от меньшего к большему).
// Phase 2: атаки (по очереди); попадание = клетка обнуляется.
// End: счётчик палуб одного игрока = 0 → второй победил.

const int N = 10;
const int TOTAL_DECKS = 4 * 1 + 3 * 2 + 2 * 3 + 1 * 4;  // = 20

// Глобальные поля (как в разборе учителя)
bool field_1[N][N];
bool field_2[N][N];

void initField(bool field[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            field[i][j] = false;
        }
    }
}

void printField(bool field[N][N]) {
    std::cout << "  ";
    for (int j = 0; j < N; j++) std::cout << j << " ";
    std::cout << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << i << " ";
        for (int j = 0; j < N; j++) {
            std::cout << (field[i][j] ? 'O' : '.') << " ";
        }
        std::cout << std::endl;
    }
}

// Добавляет корабль size клеток на field. true если получилось, false иначе.
bool addShip(bool field[N][N], int size) {
    if (size < 1) {
        std::cout << "Error: invalid ship size" << std::endl;
        return false;
    }

    int x1, y1, x2, y2;

    std::cout << "Enter start coords (x y): ";
    if (!(std::cin >> x1 >> y1)) return false;

    if (size == 1) {
        x2 = x1;
        y2 = y1;
    } else {
        std::cout << "Enter end coords (x y): ";
        if (!(std::cin >> x2 >> y2)) return false;
    }

    // Swap if user указал координаты в обратном порядке
    if (x2 < x1) { int t = x1; x1 = x2; x2 = t; }
    if (y2 < y1) { int t = y1; y1 = y2; y2 = t; }

    // Bounds check (в пределах 0..N-1)
    if (x1 < 0 || x2 >= N || y1 < 0 || y2 >= N) {
        std::cout << "Error: out of bounds [0.." << (N - 1) << "]" << std::endl;
        return false;
    }

    int dx = x2 - x1;
    int dy = y2 - y1;

    // Запрет квадратных кораблей: оба не нули = диагональ/квадрат
    if (dx != 0 && dy != 0) {
        std::cout << "Error: diagonal/square ships not allowed" << std::endl;
        return false;
    }

    // Проверка размера
    int actualSize = (dx != 0) ? (dx + 1) : (dy + 1);
    if (actualSize != size) {
        std::cout << "Error: coords describe size " << actualSize
                  << ", expected " << size << std::endl;
        return false;
    }

    // Collision check
    for (int i = x1; i <= x2; i++) {
        for (int j = y1; j <= y2; j++) {
            if (field[i][j]) {
                std::cout << "Error: collision with another ship" << std::endl;
                return false;
            }
        }
    }

    // Размещаем корабль (true в каждой клетке)
    for (int i = x1; i <= x2; i++) {
        for (int j = y1; j <= y2; j++) {
            field[i][j] = true;
        }
    }

    return true;
}

// Просит пользователя расставить все корабли (4 малых, 3 средних, 2 больших, 1 огромный)
void playShips(bool field[N][N]) {
    int counts[] = {4, 3, 2, 1};  // count per size
    int sizes[]  = {1, 2, 3, 4};  // size

    for (int s = 0; s < 4; s++) {
        std::cout << "Place " << counts[s] << " ships of size " << sizes[s] << std::endl;
        for (int n = 0; n < counts[s]; n++) {
            std::cout << "Ship " << (n + 1) << "/" << counts[s] << " (size " << sizes[s] << "):" << std::endl;
            while (!addShip(field, sizes[s])) {
                std::cout << "Try again." << std::endl;
            }
            printField(field);
        }
    }
}

// Атака: true = попал (клетка затёрта), false = промазал.
bool attack(bool field[N][N]) {
    int x, y;
    std::cout << "Attack coords (x y): ";
    if (!(std::cin >> x >> y)) return false;

    if (x < 0 || x >= N || y < 0 || y >= N || !field[x][y]) {
        std::cout << "Miss!" << std::endl;
        return false;
    }

    field[x][y] = false;
    std::cout << "Hit!" << std::endl;
    return true;
}

int main() {
    initField(field_1);
    initField(field_2);

    std::cout << "=== Battleship 10x10 ===" << std::endl;
    std::cout << "Player 1 ship placement:" << std::endl;
    playShips(field_1);
    std::cout << "Player 2 ship placement:" << std::endl;
    playShips(field_2);

    int decks_1 = TOTAL_DECKS;
    int decks_2 = TOTAL_DECKS;

    while (decks_1 > 0 && decks_2 > 0) {
        std::cout << "--- Player 1 turn (decks: 1=" << decks_1 << ", 2=" << decks_2 << ") ---" << std::endl;
        if (attack(field_2)) decks_2--;
        if (decks_2 == 0) break;

        std::cout << "--- Player 2 turn (decks: 1=" << decks_1 << ", 2=" << decks_2 << ") ---" << std::endl;
        if (attack(field_1)) decks_1--;
    }

    if (decks_2 == 0) {
        std::cout << "Player 1 wins!" << std::endl;
    } else {
        std::cout << "Player 2 wins!" << std::endl;
    }

    return 0;
}
