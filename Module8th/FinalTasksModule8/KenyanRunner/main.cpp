#include <iostream>
#include <string>
#include "usersinputcontrol.h"

int main() {
    double distanceKm, finishTimeSec;
    finishTimeSec = 0.0;
    int countKm;

    std::pair<double, bool> userInput;
    userInput = getUserInput(
            "Привет, Сэм! Сколько километров ты сегодня пробежал?-> ",
            0.1, 100,
            "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n"
    );

    if (userInput.second) return 0;
    distanceKm = userInput.first;
    countKm = 1;

    if (distanceKm < 1) {
        userInput = getUserInput(
                "Какой у тебя был темп на этой дистанции " + std::to_string(distanceKm) + "?-> ",
                0.1, 1000,
                "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n"
        );
        if (userInput.second) return 0;
        finishTimeSec = userInput.first;
    } else {
        do {
            userInput = getUserInput(
                    "Какой у тебя был темп на километре " + std::to_string(countKm) + "?-> ",
                    0.1, 1000,
                    "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n"
            );
            if (userInput.second) return 0;
            finishTimeSec += userInput.first;
            ++countKm;
        } while (countKm <= distanceKm);
    }



    std::cout << "Количество километров, которое ты сегодня пробежал: " << distanceKm  << "километра" << std::endl;
    std::cout << "Количество секунд, за которые  ты сегодня пробежал дистанцию: " << finishTimeSec << std::endl;

    return 0;
}