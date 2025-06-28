#include <iostream>
#include <string>

int main() {
    std::string text, word;
    
    std::cout << "Введите текст: ";
    std::getline(std::cin, text);
    
    std::cout << "Введите слово для поиска: ";
    std::getline(std::cin, word);
    
    int count = 0;
    size_t pos = 0;
    
    while ((pos = text.find(word, pos)) != std::string::npos) {
        count++;
        pos++;
    }
    
    std::cout << "Количество вхождений: " << count << std::endl;
    
    return 0;
}