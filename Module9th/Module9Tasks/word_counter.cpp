#include <iostream>
#include <string>

int countWords(const std::string& text) {
    if (text.empty()) return 0;
    
    int wordCount = 0;
    bool inWord = false;
    
    for (char c : text) {
        if (c != ' ') {
            // Если мы не внутри слова, начинаем новое слово
            if (!inWord) {
                wordCount++;
                inWord = true;
            }
        } else {
            // Пробел - заканчиваем текущее слово
            inWord = false;
        }
    }
    
    return wordCount;
}

int main() {
    std::string input;
    std::cout << "Введите строку:" << std::endl;
    std::getline(std::cin, input);
    
    int words = countWords(input);
    std::cout << "Ответ: " << words << std::endl;
    
    return 0;
}