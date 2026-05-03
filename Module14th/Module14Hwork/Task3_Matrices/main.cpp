#include <iostream>

// Сравнение двух 4×4 матриц на полное равенство.
// Если равны → одну преобразуем к диагональному виду.
// Алгоритм оптимальный: при первом несоответствии прекращаем сравнение.

const int N = 4;

// Optimal compare с early break при первом mismatch
bool matricesEqual(int a[N][N], int b[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (a[i][j] != b[i][j]) {
                return false;   // first mismatch → exit
            }
        }
    }
    return true;
}

// Преобразование к diagonal: всё кроме arr[i][i] обнуляется
void diagonalize(int matrix[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (i != j) {
                matrix[i][j] = 0;
            }
        }
    }
}

void readMatrix(int matrix[N][N], const char* name) {
    std::cout << "Enter matrix " << name << " (" << N << "x" << N << "):" << std::endl;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            std::cin >> matrix[i][j];
        }
    }
}

void printMatrix(int matrix[N][N], const char* name) {
    std::cout << name << ":" << std::endl;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            std::cout << matrix[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    int A[N][N], B[N][N];

    readMatrix(A, "A");
    readMatrix(B, "B");

    if (!matricesEqual(A, B)) {
        std::cout << "Matrices are NOT equal." << std::endl;
        return 0;
    }

    std::cout << "Matrices are EQUAL." << std::endl;

    // Преобразовать A к диагональному виду
    diagonalize(A);
    printMatrix(A, "Diagonalized A");

    return 0;
}
