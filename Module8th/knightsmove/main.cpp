#include "knightsmove.h"
#include <iostream>

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
