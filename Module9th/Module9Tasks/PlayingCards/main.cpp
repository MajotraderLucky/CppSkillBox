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

  int firstCardIndex = findCardIndex(firstCard, cardsArray);
  int secondCardIndex = findCardIndex(secondCard, cardsArray);

  std::cout << "First card index: " << firstCardIndex << std::endl;
  std::cout << "Second card index: " << secondCardIndex << std::endl;

  bool firstCardA = (firstCardIndex == 8 && secondCardIndex == 0);
  bool secondCardA = (firstCardIndex == 0 && secondCardIndex == 8);
  bool firstCardIsBigger = (firstCardIndex > secondCardIndex);
  bool secondCardIsBigger = (firstCardIndex < secondCardIndex);
  bool errorCard = (firstCardIndex == -1 || secondCardIndex == -1);

  if (!errorCard) {
    if (secondCardA) {
      std::cout << "The first card is bigger" << std::endl;
    } else if (firstCardA) {
      std::cout << "The second card is bigger" << std::endl;
    } else if (firstCardIsBigger) {
      std::cout << "The first card is bigger" << std::endl;
    } else if (secondCardIsBigger) {
      std::cout << "The second card is bigger" << std::endl;
    }
  } else {
    std::cout << "Error: one of the cards is incorrect" << std::endl;
  }
}