// M33.5 Task 4 — шаблонная функция среднего арифметического в массиве [8].
//
// Запуск:
//   ./average                 — int (default), интерактивный ввод
//   ./average --type=int      — int
//   ./average --type=double   — double
//   ./average --type=float    — float
//   ./average --type=long     — long

#include <iostream>
#include <string>

template <typename T>
void input(T array[8]) {
    std::cout << "Fill the array (8):" << std::endl;
    for (int i = 0; i < 8; ++i) {
        std::cin >> array[i];
    }
}

template <typename T>
double average(const T array[8]) {
    double sum = 0;
    for (int i = 0; i < 8; ++i) sum += static_cast<double>(array[i]);
    return sum / 8.0;
}

int main(int argc, char** argv) {
    std::string type = "int";
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--type=", 0) == 0) type = a.substr(7);
    }

    if (type == "int") {
        int    arr[8];
        input(arr);
        std::cout << average(arr) << std::endl;
    } else if (type == "double") {
        double arr[8];
        input(arr);
        std::cout << average(arr) << std::endl;
    } else if (type == "float") {
        float  arr[8];
        input(arr);
        std::cout << average(arr) << std::endl;
    } else if (type == "long") {
        long   arr[8];
        input(arr);
        std::cout << average(arr) << std::endl;
    } else {
        std::cerr << "Unsupported --type=" << type << std::endl;
        return 1;
    }
    return 0;
}
