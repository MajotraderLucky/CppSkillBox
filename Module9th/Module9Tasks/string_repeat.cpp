#include <iostream>
#include <string>

int main() {
    std::string s;
    std::cout << "Введите строку: ";
    std::getline(std::cin, s);
    
    int n = s.length();
    bool found = false;
    
    for (int len = 1; len <= n / 2; len++) {
        if (n % len == 0) {
            std::string pattern = s.substr(0, len);
            bool matches = true;
            
            for (int i = len; i < n; i += len) {
                if (s.substr(i, len) != pattern) {
                    matches = false;
                    break;
                }
            }
            
            if (matches) {
                found = true;
                break;
            }
        }
    }
    
    std::cout << (found ? "Yes" : "No") << std::endl;
    
    return 0;
}