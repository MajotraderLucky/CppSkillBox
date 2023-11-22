#ifndef USERSINPUTCONTROL_HPP
#define USERSINPUTCONTROL_HPP

#include <string>

bool isDigitsOnly(const std::string& input);

std::string containsDigitsAndDot(const std::string& input);

double convertToDouble(const std::string& input);

bool isInRange(double number, double lowerBound, double upperBound);

bool compareStrings(const std::string& str1, const std::string& str2);

void processUserInput(const std::string& userInput);

#endif