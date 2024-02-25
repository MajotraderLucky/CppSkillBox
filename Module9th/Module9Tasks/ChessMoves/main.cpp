#include <iostream>
#include "chessmoves.h"

// Function to check if a move corresponds to a rook's move in chess
bool isRookMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // A rook's move in chess corresponds to either a horizontal or a vertical movement.
    // Therefore, if the start and end points match vertically (by letter) or horizontally (by number),
    // it means the move was made by a rook.
    return letterStartPoint == letterEndPoint || numberStartPoint == numberEndPoint;
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
  bool isRookMoveValid = isRookMove(letterStartPoint, numberStartPoint, letterEndPoint, numberEndPoint);

  if (isStartPointValid && isEndPointValid) {
    std::cout << "The move of the figure is valid" << std::endl;
    std::cout << std::boolalpha;  // Print boolean as true/false instead of 1/0.
    std::cout << "isKnightMoveValid: " << isKnightMoveValid << std::endl;
    std::cout << "isKingMoveValid: " << isKingMoveValid << std::endl;
    std::cout << "isRookMoveValid: " << isRookMoveValid << std::endl;

  } else {
    std::cout << "The move of the figure is not valid" << std::endl;
  }

  return 0;
}
