#include <iostream>

int main() {
  std::cout << "Enter a start point on the chess board" << std::endl;
  char startPoint;
  std::cin >> startPoint;

  char letter_coordinat[8] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
  int count = 0;
  for (int i = 0; i < 8; i++) {
    if (letter_coordinat[i] != startPoint) {
      count++;
    }
  }

  if (count == 8) {
    std::cout << "The point is not on the board" << std::endl;
  } else {
    std::cout << "The point is on the board" << std::endl;
  }

  return 0;
}