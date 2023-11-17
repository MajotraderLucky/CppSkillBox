#include <iostream>
#include <cmath>
#include <iomanip>

int convertDoubleToInt(double number) {
  double fractionalPart = number - std::trunc(number); // отсекаем целую часть
  double tenthPart = fractionalPart * 10; // берем десятую часть числа
  int convertedNumber = static_cast<int>(tenthPart);
  return convertedNumber;
}

double getDoubleFromInput() {
  double input;
  
  while (true) {
    std::cin >> input;
    
    if (std::cin.fail()) { // если предыдущее извлечение не удалось,
      std::cin.clear(); // возвращаем cin в 'обычный' режим работы
      std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // удаляем значения предыдущего ввода из входного буфера
      std::cout << "Пожалуйста, введите корректное число:\n";
    } 
    else if (input < 0) {
      std::cout << "Пожалуйста, введите положительное число:\n";
    } 
    else {
      break;
    }
  }
  
  return input;  
}

int main() {
   // Запрос ввода координат коня
  std::cout << "Введите местоположение коня:\n";
  double knightX = getDoubleFromInput();
  double knightY = getDoubleFromInput();

  std::cout << "Введите местоположение точки на доске:\n";
  double pointX = getDoubleFromInput();
  double pointY = getDoubleFromInput();

  int knightXint = convertDoubleToInt(knightX);
  int knightYint = convertDoubleToInt(knightY);
  int pointXint = convertDoubleToInt(pointX);
  int pointYint = convertDoubleToInt(pointY);

  std::cout << knightXint << "--" << knightYint << "\n";
  std::cout << pointXint << "--" << pointYint << "\n";

  return 0;
}