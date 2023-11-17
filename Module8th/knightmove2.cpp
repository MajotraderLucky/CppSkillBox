#include <iostream>
#include <cmath>

int convertDoubleToInt(double number) {
  double fractionalPart = number - std::trunc(number); // отсекаем целую часть
  double tenthPart = fractionalPart * 10; // берем десятую часть числа
  int convertedNumber = static_cast<int>(tenthPart);
  return convertedNumber;
}

int main() {
   // Запрос ввода координат коня
  std::cout << "Введите местоположение коня:\n";
  double knightX, knightY;
  std::cin >> knightX >> knightY;

  // Запрос ввода координат точки на доске
  std::cout << "Введите местоположение точки на доске:\n";
  double pointX, pointY;
  std::cin >> pointX >> pointY;

  int knightXint = convertDoubleToInt(knightX);
  int knightYint = convertDoubleToInt(knightY);
  int pointXint = convertDoubleToInt(pointX);
  int pointYint = convertDoubleToInt(pointY);

  std::cout << knightXint << "--" << knightYint << "\n";
  std::cout << pointXint << "--" << pointYint << "\n";

  return 0;
}