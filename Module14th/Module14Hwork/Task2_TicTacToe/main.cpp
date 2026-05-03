#include <iostream>

// Крестики-нолики 3×3
// Игроки X и O ходят по очереди, координаты вводят (row col).
// Win = 3 подряд горизонтально или вертикально (без диагоналей по условию).
// При занятой клетке или out-of-bounds → ошибка + повтор.

const int N = 3;
const char EMPTY = ' ';

void printBoard(char board[N][N]) {
    std::cout << "  0 1 2" << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << i << " ";
        for (int j = 0; j < N; j++) {
            std::cout << board[i][j];
            if (j < N - 1) std::cout << "|";
        }
        std::cout << std::endl;
        if (i < N - 1) std::cout << "  -+-+-" << std::endl;
    }
}

// Проверяет победу — true если есть 3 подряд (горизонталь или вертикаль)
bool checkWin(char board[N][N], char symbol) {
    for (int i = 0; i < N; i++) {
        // Horizontal: row i
        bool rowWin = true;
        for (int j = 0; j < N; j++) {
            if (board[i][j] != symbol) { rowWin = false; break; }
        }
        if (rowWin) return true;

        // Vertical: column i
        bool colWin = true;
        for (int j = 0; j < N; j++) {
            if (board[j][i] != symbol) { colWin = false; break; }
        }
        if (colWin) return true;
    }
    return false;
}

int main() {
    char board[N][N];
    // Init: все клетки = пробел
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            board[i][j] = EMPTY;
        }
    }

    char player = 'X';
    int movesPlayed = 0;
    const int MAX_MOVES = N * N;

    std::cout << "=== Tic-Tac-Toe 3x3 ===" << std::endl;
    std::cout << "Coords: row col (0-2 each)" << std::endl;
    printBoard(board);

    while (movesPlayed < MAX_MOVES) {
        int row, col;
        std::cout << "Player " << player << " move: ";
        if (!(std::cin >> row >> col)) {
            std::cout << "Invalid input. Game over." << std::endl;
            return 1;
        }

        // Validate bounds
        if (row < 0 || row >= N || col < 0 || col >= N) {
            std::cout << "Out of bounds. Try again." << std::endl;
            continue;
        }

        // Validate cell empty
        if (board[row][col] != EMPTY) {
            std::cout << "Cell already taken. Try again." << std::endl;
            continue;
        }

        // Place symbol
        board[row][col] = player;
        movesPlayed++;

        printBoard(board);

        // Check win
        if (checkWin(board, player)) {
            std::cout << "Player " << player << " wins!" << std::endl;
            return 0;
        }

        // Switch player
        if (player == 'X') {
            player = 'O';
        } else {
            player = 'X';
        }
    }

    // No winner после MAX_MOVES
    std::cout << "Draw!" << std::endl;
    return 0;
}
