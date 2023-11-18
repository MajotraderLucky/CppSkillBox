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
  double fractionalPart = number - std::trunc(number);
  int convertedNumber = static_cast<int>(fractionalPart * 10);
  return convertedNumber;
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

int main() {
   // Request for the input of the knight's coordinates
  std::cout << "Enter the location of the knight:\n";
  double knightX = getDoubleFromInput();
  double knightY = getDoubleFromInput();

  std::cout << "Enter a point on the board:\n";
  double pointX = getDoubleFromInput();
  double pointY = getDoubleFromInput();

    std::cout << "-----------------------" << std::endl;

  std::cout << knightX << "--" << knightY << "\n";
  std::cout << pointX << "--" << pointY << "\n";

  int knightXint = convertDoubleToInt(knightX);
  int knightYint = convertDoubleToInt(knightY);
  int pointXint = convertDoubleToInt(pointX);
  int pointYint = convertDoubleToInt(pointY);

  std::cout << "-----------------------" << std::endl;
  std::cout << knightXint << "--" << knightYint << "\n";
  std::cout << pointXint << "--" << pointYint << "\n";
  std::cout << "-----------------------" << std::endl;

  if (isKnightMoveValid(knightXint, knightYint, pointXint, pointYint)) {
    std::cout << "The knight can move to the point\n";
  } else {
    std::cout << "The knight cannot move to the point\n";
  }

  return 0;
}
