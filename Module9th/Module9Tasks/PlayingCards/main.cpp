#include <iostream>
#include "playingcards.h"

int main() {
  char firstCard, secondCard;
  bool cardIncorrect;
  std::cout << "Input the name of the two cards: " << std::endl;
  std::cin >> firstCard >> secondCard;

  if (!isValidCard(firstCard)) {
    std::cout << "The data of the first card is incorrect!" << std::endl;
  } else {
    std::cout << "The data of the first card is correct" << std::endl;
  }
  
  if (!isValidCard(secondCard)) {
    std::cout << "The data of the second card is incorrect!" << std::endl;
  } else {
    std::cout << "The data of the second card is correct" << std::endl;
  }
}