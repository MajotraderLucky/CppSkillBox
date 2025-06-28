#include <iostream>
#include <string>

void countBullsAndCows(const std::string& secret, const std::string& guess, int& bulls, int& cows) {
    bulls = 0;
    cows = 0;
    
    // Массивы для подсчета частоты цифр
    int secretCount[10] = {0};
    int guessCount[10] = {0};
    
    // Сначала считаем быков (точные совпадения по позиции)
    for (int i = 0; i < 4; ++i) {
        if (secret[i] == guess[i]) {
            bulls++;
        } else {
            // Увеличиваем счетчики для цифр, которые не являются быками
            secretCount[secret[i] - '0']++;
            guessCount[guess[i] - '0']++;
        }
    }
    
    // Теперь считаем коров (совпадения по значению, но не по позиции)
    for (int digit = 0; digit <= 9; ++digit) {
        cows += std::min(secretCount[digit], guessCount[digit]);
    }
}

int main() {
    std::string secret, guess;
    
    std::cout << "Введите задуманное число: ";
    std::cin >> secret;
    
    std::cout << "Введите второе число: ";
    std::cin >> guess;
    
    // Дополняем числа нулями слева до 4 цифр, если нужно
    while (secret.length() < 4) {
        secret = "0" + secret;
    }
    while (guess.length() < 4) {
        guess = "0" + guess;
    }
    
    int bulls, cows;
    countBullsAndCows(secret, guess, bulls, cows);
    
    std::cout << "Быков: " << bulls << ", коров: " << cows << std::endl;
    
    return 0;
}