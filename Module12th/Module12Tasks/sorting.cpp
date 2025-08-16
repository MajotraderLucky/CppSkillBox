#include <iostream>

int main() {
    const int SIZE = 15;
    float numbers[SIZE];
    
    // Ввод 15 чисел
    std::cout << "Введите 15 дробных чисел:" << std::endl;
    for (int i = 0; i < SIZE; ++i) {
        std::cin >> numbers[i];
    }
    
    // Пузырьковая сортировка по убыванию с оптимизацией
    bool swapped;
    for (int i = 0; i < SIZE - 1; ++i) {
        swapped = false;
        for (int j = 0; j < SIZE - i - 1; ++j) {
            if (numbers[j] < numbers[j + 1]) {
                // Обмен элементов
                float temp = numbers[j];
                numbers[j] = numbers[j + 1];
                numbers[j + 1] = temp;
                swapped = true;
            }
        }
        // Если обменов не было, массив отсортирован
        if (!swapped) {
            break;
        }
    }
    
    // Вывод отсортированных чисел
    std::cout << "Числа в порядке убывания:" << std::endl;
    for (int i = 0; i < SIZE; ++i) {
        std::cout << numbers[i];
        if (i < SIZE - 1) {
            std::cout << " ";
        }
    }
    std::cout << std::endl;
    
    return 0;
}