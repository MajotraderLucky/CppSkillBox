#include <iostream>
#include <cmath>
#include "chessmoves.h"

bool isKnightMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // Calculate the difference between the start and end coordinates.
    int dx = std::abs(letterStartPoint - letterEndPoint);
    int dy = std::abs(numberStartPoint - numberEndPoint);
    
    // Check if the move is valid for a knight.
    return (dx == 2 && dy == 1) || (dx == 1 && dy == 2);
}

int main() {
  std::cout << "Enter a start point on the chess board" << std::endl;
  char letterStartPoint;
  int numberStartPoint;
  std::cin >> letterStartPoint >> numberStartPoint;

  bool isStartPointValid = isOnBoard(letterStartPoint, numberStartPoint);

  if (!isStartPointValid) {
    std::cout << "The start point is not on the board" << std::endl;
  } else {
    std::cout << "The start point is on the board" << std::endl;
  }

  std::cout << "Enter an end point on the chess board" << std::endl;
  char letterEndPoint;
  int numberEndPoint;
  std::cin >> letterEndPoint >> numberEndPoint;

  bool isEndPointValid = isOnBoard(letterEndPoint, numberEndPoint) 
    && !(numberEndPoint == numberStartPoint && letterEndPoint == letterStartPoint);

  if (!isEndPointValid) {
    std::cout << "The end point is not on the board" << std::endl;
  } else {
    std::cout << "The end point is on the board" << std::endl;
  }

  bool isKnightMoveValid = isKnightMove(letterStartPoint, numberStartPoint, letterEndPoint, numberEndPoint);

  if (isStartPointValid && isEndPointValid) {
    std::cout << "The move of the figure is valid" << std::endl;
    std::cout << std::boolalpha;  // Print boolean as true/false instead of 1/0.
    std::cout << isKnightMoveValid << std::endl;
  } else {
    std::cout << "The move of the figure is not valid" << std::endl;
  }

  return 0;
}
