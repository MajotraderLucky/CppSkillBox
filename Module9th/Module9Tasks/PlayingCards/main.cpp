#include <iostream>
#include "playingcards.h"

int findCardIndex(char card, char charArray[9]) {
  for (int i = 0; i < 9; i++) {
    if (charArray[i] == card) {
      return i;
    }
  }
  return -1;
}

int main() {
  char firstCard, secondCard;
  bool cardIncorrect;
  char cardsArray[9] = {'6', '7', '8', '9', '0', 'J', 'Q', 'K', 'A'};

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

  if (isValidCard(firstCard) && isValidCard(secondCard)) {
    std::cout << "First card: " << firstCard << "-" << static_cast<int>(firstCard) << std::endl;
    std::cout << "Second card: " << secondCard << "-" << static_cast<int>(secondCard) << std::endl;
  }

  int firstCardIndex = findCardIndex(firstCard, cardsArray);
  int secondCardIndex = findCardIndex(secondCard, cardsArray);

  std::cout << "First card index: " << firstCardIndex << std::endl;
  std::cout << "Second card index: " << secondCardIndex << std::endl;
}