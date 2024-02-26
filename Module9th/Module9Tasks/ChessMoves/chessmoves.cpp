#include <iostream>
#include "chessmoves.h"
#include <cmath>

// Function to check if a point is within the board
bool isOnBoard(char letter, int number) {
  char letter_coordinat[8] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
  int count = 0;
  for (int i = 0; i < 8; i++) {
    if (letter_coordinat[i] != letter) {
      count++;
    }
  }

  // Check that the number is in the range from 1 to 8 and the letter is in the array
  return !(count == 8 || number < 1 || number > 8);
}

bool isKnightMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // Calculate the difference between the start and end coordinates.
    int dx = std::abs(letterStartPoint - letterEndPoint);
    int dy = std::abs(numberStartPoint - numberEndPoint);
    
    // Check if the move is valid for a knight.
    return (dx == 2 && dy == 1) || (dx == 1 && dy == 2);
}

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

// Function to check if a move corresponds to a rook's move in chess
bool isRookMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // A rook's move in chess corresponds to either a horizontal or a vertical movement.
    // Therefore, if the start and end points match vertically (by letter) or horizontally (by number),
    // it means the move was made by a rook.
    return letterStartPoint == letterEndPoint || numberStartPoint == numberEndPoint;
}

// Function to check if the move corresponds to the chess bishop's move
bool isBishopMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint) {
    // In chess, a bishop's move corresponds to diagonal movement.
    // This means that the absolute difference between the start and end points horizontally (letters)
    // should be equal to the absolute difference between the start and end points vertically (numbers).
    return std::abs(letterStartPoint - letterEndPoint) == std::abs(numberStartPoint - numberEndPoint);
}