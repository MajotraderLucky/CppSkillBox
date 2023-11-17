#include <iostream>
#include <cmath>

int main() {
  // Запрос ввода координат коня
  std::cout << "Введите местоположение коня:\n";
  double knightX, knightY;
  std::cin >> knightX >> knightY;

  // Запрос ввода координат точки на доске
  std::cout << "Введите местоположение точки на доске:\n";
  double pointX, pointY;
  std::cin >> pointX >> pointY;

// Преобразование координат в целочисленные значения
int knightCellX = static_cast<int>(std::floor(knightX * 8)) + 1;
int knightCellY = static_cast<int>(std::floor(knightY * 8)) + 1;
int pointCellX = static_cast<int>(std::floor(pointX * 8)) + 1;
int pointCellY = static_cast<int>(std::floor(pointY * 8)) + 1;

// Вычисление разницы между координатами коня и точки
int diffX = std::abs(knightCellX - pointCellX);
int diffY = std::abs(knightCellY - pointCellY);

// Проверка возможности хода конём
bool canKnightMove = (diffX == 2 && diffY == 1) || (diffX == 1 && diffY ==2);

// Вывод результата
std::cout << "\nКонь в клетке (" << knightCellX << ", " << knightCellY << ").\n"
            << "Точка в клетке (" << pointCellX << ", " << pointCellY << ").\n";

  if (canKnightMove) {
    std::cout << "Да, конь может ходить в эту точку.\n";
  } else {
    std::cout << "Нет, конь не может ходить в эту точку.\n";
  }

  return 0;
}
