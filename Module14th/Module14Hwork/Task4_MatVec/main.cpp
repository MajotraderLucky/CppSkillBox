#include <iomanip>
#include <iostream>

// Умножение матрицы 4×4 на вектор длины 4 → результирующий вектор длины 4.
// c[i] = Σ_k a[i][k] * b[k]
// Распространено в компьютерной графике (transformation matrices).

const int N = 4;

void multiplyMatVec(float a[N][N], float b[N], float c[N]) {
    for (int i = 0; i < N; i++) {
        // Аккумулятор для одной компоненты результата
        float sum = 0;
        for (int k = 0; k < N; k++) {
            sum += a[i][k] * b[k];
        }
        c[i] = sum;
    }
}

void readMatrix(float a[N][N]) {
    std::cout << "Enter matrix A (" << N << "x" << N << "):" << std::endl;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            std::cin >> a[i][j];
        }
    }
}

void readVector(float b[N]) {
    std::cout << "Enter vector b (" << N << " elements):" << std::endl;
    for (int i = 0; i < N; i++) {
        std::cin >> b[i];
    }
}

int main() {
    float a[N][N];
    float b[N];
    float c[N];

    readMatrix(a);
    readVector(b);

    multiplyMatVec(a, b, c);

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Result c = ";
    for (int i = 0; i < N; i++) {
        std::cout << c[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
