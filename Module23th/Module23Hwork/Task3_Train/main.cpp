// M23.4 Task 3 — Анализ заполненности вагонов через макросы.
// Spec: 10 вагонов, оптимум 20 пассажиров.
// Вывод: переполненные → недозаполненные → общее количество.
// Цикл for напрямую запрещён — оборачиваем в макрос.

#include <iostream>

constexpr int N_CARS  = 10;
constexpr int OPTIMAL = 20;

// Макрос-итератор: применяет func к каждому элементу.
#define FOR_EACH(arr, n, func) { for (int _i = 0; _i < (n); ++_i) func((arr)[_i], _i); }

// Макрос-итератор для ввода: cin >> arr[i].
#define READ_ALL(arr, n) { for (int _i = 0; _i < (n); ++_i) std::cin >> (arr)[_i]; }

int g_total = 0;

void checkOverfull(int passengers, int carIdx) {
    if (passengers > OPTIMAL) {
        std::cout << "OVER car " << (carIdx + 1) << ": " << passengers << "\n";
    }
}

void checkUnderfull(int passengers, int carIdx) {
    if (passengers < OPTIMAL) {
        std::cout << "UNDER car " << (carIdx + 1) << ": " << passengers << "\n";
    }
}

void accumulate(int passengers, int /*carIdx*/) {
    g_total += passengers;
}

int main() {
    int cars[N_CARS] = {0};
    std::cerr << "Введите количество пассажиров для " << N_CARS << " вагонов:\n";
    READ_ALL(cars, N_CARS);

    FOR_EACH(cars, N_CARS, checkOverfull);
    FOR_EACH(cars, N_CARS, checkUnderfull);
    FOR_EACH(cars, N_CARS, accumulate);

    std::cout << "TOTAL: " << g_total << "\n";
    return 0;
}
