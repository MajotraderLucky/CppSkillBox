#include <iostream>
#include <cmath>

bool isOnBoard(char letter, int number);
bool isKnightMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint);
bool isKingMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint);
bool isRookMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint);
bool isBishopMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint);
bool isQueenMove(char letterStartPoint, int numberStartPoint, char letterEndPoint, int numberEndPoint);