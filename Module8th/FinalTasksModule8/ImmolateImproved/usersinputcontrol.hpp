#ifndef USERSINPUTCONTROL_HPP
#define USERSINPUTCONTROL_HPP

#include <string>

bool isDigitsOnly(const std::string& input);

std::string containsDigitsAndDot(const std::string& input);

double convertToDouble(const std::string& input);

bool isInRange(double number, double lowerBound, double upperBound);

bool compareStrings(const std::string& str1, const std::string& str2);

std::pair<double, bool> processUserInput(const std::string& userInput);

void printResult(const std::pair<double, bool>& result);

std::pair<double, bool> getUserInput(
    const std::string& prompt, 
    double min, double max, 
    const std::string& errorMsg);

#endif