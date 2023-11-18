#include "knightsmove.h"
#include <iostream>
#include <cmath>
#include <iomanip>
#include <limits>

double getDoubleFromInput() {
  double input;
  
  while (true) {
    std::cin >> input;
    
    // проверяем, что ввод не вызвал ошибку и что число не отрицательно
    if (std::cin.fail() || input < 0) { 
      std::cin.clear(); // возвращаем cin в 'обычный' режим работы
      std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // удаляем значения предыдущего ввода из входного буфера
      std::cout << "Please enter a positive number:\n";
    } else {
      // проверяем, что дробная часть числа находится в промежутке от 0 до 7
      int converted = static_cast<int>(input * 10) % 10;

      if (converted < 0 || converted > 7) {
        std::cout << "Please enter a number greater than or equal to 0.0 and less than or equal to 0.7:\n";
      } else {
        break;
      }
    }
  }
  
  return input;
}

int convertDoubleToInt(double number) {
    if (number<0) return -1;
    double decimal_part = number - static_cast<int>(number) + 0.000001; // Добавляем малую константу
    return static_cast<int>(decimal_part * 10);
}

bool isKnightMoveValid(int x1, int y1, int x2, int y2) {
    int dx = abs(x1 - x2);
    int dy = abs(y1 - y2);

    if ((dx == 1 && dy == 2) || (dx == 2 && dy == 1)) {
        return true;
    } else {
        return false;
    }
}