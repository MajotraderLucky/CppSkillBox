#include "playingcards.h"

bool isValidCard(char card) {
  return (card >= '6' && card <= '9') 
  || (card == 'J') || (card == 'Q') 
  || (card == 'K') || (card == 'A') || (card == '0');
}