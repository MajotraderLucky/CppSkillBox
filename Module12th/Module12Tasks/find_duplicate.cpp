#include <iostream>

int main() {
    // Инициализированный массив из примера
    int numbers[15] = {114, 111, 106, 107, 108, 105, 115, 108, 110, 109, 112, 113, 116, 117, 118};
    
    // Найдем минимальное и максимальное значения за один проход O(n)
    int min = numbers[0];
    int max = numbers[0];
    int actualSum = 0;
    
    for (int i = 0; i < 15; ++i) {
        if (numbers[i] < min) min = numbers[i];
        if (numbers[i] > max) max = numbers[i];
        actualSum += numbers[i];
    }
    
    // Сумма последовательности от min до max включительно
    // Формула: сумма = n * (первый + последний) / 2
    // где n = количество элементов в последовательности
    int n = max - min + 1;  // количество чисел от min до max
    int expectedSum = n * (min + max) / 2;
    
    // Разница между фактической и ожидаемой суммой - это повторяющееся число
    int duplicate = actualSum - expectedSum;
    
    std::cout << "Диапазон чисел: от " << min << " до " << max << std::endl;
    std::cout << "Повторяющееся число: " << duplicate << std::endl;
    
    return 0;
}