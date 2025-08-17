#include <iostream>

// Функция для построения кучи (heapify)
void heapify(float arr[], int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    
    // Если левый потомок больше корня
    if (left < n && arr[left] > arr[largest]) {
        largest = left;
    }
    
    // Если правый потомок больше самого большого элемента
    if (right < n && arr[right] > arr[largest]) {
        largest = right;
    }
    
    // Если самый большой элемент не корень
    if (largest != i) {
        float temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;
        
        // Рекурсивно строим кучу для поддерева
        heapify(arr, n, largest);
    }
}

// Основная функция пирамидальной сортировки
void heapSort(float arr[], int n) {
    // Построение кучи (перегруппировка массива)
    for (int i = n / 2 - 1; i >= 0; --i) {
        heapify(arr, n, i);
    }
    
    // Извлечение элементов из кучи по одному
    for (int i = n - 1; i > 0; --i) {
        // Перемещаем текущий корень в конец
        float temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;
        
        // Вызываем heapify на уменьшенной куче
        heapify(arr, i, 0);
    }
}

int main() {
    const int SIZE = 15;
    float numbers[SIZE];
    
    // Ввод 15 чисел
    std::cout << "Введите 15 дробных чисел:" << std::endl;
    for (int i = 0; i < SIZE; ++i) {
        std::cin >> numbers[i];
    }
    
    // Пирамидальная сортировка (HeapSort)
    // Гарантированная сложность: O(n log n), что меньше O(n^2)
    heapSort(numbers, SIZE);
    
    // Так как HeapSort сортирует по возрастанию, а нам нужно по убыванию,
    // выводим массив в обратном порядке
    std::cout << "Числа в порядке убывания:" << std::endl;
    for (int i = SIZE - 1; i >= 0; --i) {
        std::cout << numbers[i];
        if (i > 0) {
            std::cout << " ";
        }
    }
    std::cout << std::endl;
    
    return 0;
}