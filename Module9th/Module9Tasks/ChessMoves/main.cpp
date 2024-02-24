#include <iostream>
#include "chessmoves.h"
#include <cmath>

bool isKingMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // Converting char to ASCII code
    int startLetter = static_cast<int>(letterStartPoint);
    int endLetter = static_cast<int>(letterEndPoint);

    // Checking if the move is valid for a king
    if(abs(startLetter - endLetter) <= 1 && abs(numberStartPoint - numberEndPoint) <= 1) {
        return true;
    } else {
        return false;
    }
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
  bool isKingMoveValid = isKingMove(letterStartPoint, numberStartPoint, letterEndPoint, numberEndPoint);

  if (isStartPointValid && isEndPointValid) {
    std::cout << "The move of the figure is valid" << std::endl;
    std::cout << std::boolalpha;  // Print boolean as true/false instead of 1/0.
    std::cout << "isKnightMoveValid: " << isKnightMoveValid << std::endl;
    std::cout << "isKingMoveValid: " << isKingMoveValid << std::endl;

  } else {
    std::cout << "The move of the figure is not valid" << std::endl;
  }

  return 0;
}
