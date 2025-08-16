#include <iostream>
#include <iterator>  // для std::size()

int main() {
    int numbers[]{11, 12, 13, 14};
    
    // Способ 1: sizeof
    std::cout << "Способ 1 (sizeof): " << sizeof(numbers) / sizeof(numbers[0]) << std::endl;
    
    // Способ 2: std::size() - требует C++17
    std::cout << "Способ 2 (std::size): " << std::size(numbers) << std::endl;
    
    // Пример с другими типами
    double prices[]{19.99, 29.99, 39.99};
    std::cout << "Массив double: " << std::size(prices) << " элементов" << std::endl;
    
    char letters[]{'a', 'b', 'c', 'd', 'e'};
    std::cout << "Массив char: " << std::size(letters) << " элементов" << std::endl;
    
    return 0;
}