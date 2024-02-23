#include <iostream>

int main() {
  std::cout << "Enter a start point on the chess board" << std::endl;
  char letterStartPoint;
  int numberStartPoint;
  std::cin >> letterStartPoint >> numberStartPoint;

  char letter_coordinat[8] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
  int count = 0;
  for (int i = 0; i < 8; i++) {
    if (letter_coordinat[i] != letterStartPoint) {
      count++;
    }
  }

  if ((count == 8) || (numberStartPoint < 1 || numberStartPoint > 8)) { //added logical operators
    std::cout << "The start point is not on the board" << std::endl;
  } else {
    std::cout << "The start point is on the board" << std::endl;
  }

  std::cout << "Enter an end point on the chess board" << std::endl;
  char letterEndPoint;
  int numberEndPoint;
  std::cin >> letterEndPoint >> numberEndPoint;

  count = 0;
  for (int i = 0; i < 8; i++) {
    if (letter_coordinat[i] != letterEndPoint) {
      count++;
    }
  }

  if ((count == 8) || (numberEndPoint < 1 || numberEndPoint > 8) || (numberEndPoint == numberStartPoint && letterEndPoint == letterStartPoint)) { //fixed condition
    std::cout << "The end point is not on the board" << std::endl;
  } else {
    std::cout << "The end point is on the board" << std::endl;
  }

  return 0;
}
