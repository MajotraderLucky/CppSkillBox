#include <iostream>
#include <string>
#include <vector>

std::string intToRoman(int num) {
    // Массивы со значениями и соответствующими римскими символами
    // Включаем особые случаи для 4 и 9 в каждом разряде
    std::vector<int> values = {
        1000, 900, 500, 400,
        100, 90, 50, 40,
        10, 9, 5, 4, 1
    };
    
    std::vector<std::string> symbols = {
        "M", "CM", "D", "CD",
        "C", "XC", "L", "XL",
        "X", "IX", "V", "IV", "I"
    };
    
    std::string result = "";
    
    // Проходим по всем значениям от больших к меньшим
    for (int i = 0; i < values.size(); ++i) {
        // Пока число больше или равно текущему значению
        while (num >= values[i]) {
            result += symbols[i];  // Добавляем соответствующий символ
            num -= values[i];      // Вычитаем значение из числа
        }
    }
    
    return result;
}

int main() {
    int number;
    std::cout << "Введите число (1-3999): ";
    std::cin >> number;
    
    if (number < 1 || number > 3999) {
        std::cout << "Число должно быть в диапазоне от 1 до 3999" << std::endl;
        return 1;
    }
    
    std::string roman = intToRoman(number);
    std::cout << roman << std::endl;
    
    return 0;
}