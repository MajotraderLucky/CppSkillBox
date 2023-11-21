#include "usersinputcontrol.hpp"
#include <cctype> // for isdigit() function

bool isDigitsOnly(const std::string& input) {
    for (char c : input) {
        if (!std::isdigit(c)) {
            return false;
        }
    }
    return true;
}