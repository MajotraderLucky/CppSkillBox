#include <iostream>
#include "chessmoves.h"

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