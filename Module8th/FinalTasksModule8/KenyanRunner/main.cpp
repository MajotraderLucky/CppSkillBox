#include <iostream>
#include <string>
#include <cmath>
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
    double distanceMeters = distanceKm * 1000; // Конвертация в метры
    int roundedDistance = static_cast<int>(std::round(distanceMeters));

    if (distanceKm < 1) {
        userInput = getUserInput(
                "Какой у тебя был темп на этой дистанции " + std::to_string(roundedDistance) + " м ?-> ",
                0.1, 1000,
                "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n"
        );
        if (userInput.second) return 0;
        finishTimeSec = userInput.first * distanceKm; // Calculate finish time for the entire run
    } else {
        do {
            userInput = getUserInput(
                    "Какой у тебя был темп на километре " + std::to_string(countKm) + "?-> ",
                    0.1, 1000,
                    "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n"
            );
            if (userInput.second) return 0;
            finishTimeSec += userInput.first;
            ++countKm;
        } while (countKm <= distanceKm);
    }

    double averagePace = finishTimeSec / distanceKm;

    int minutes = static_cast<int>(averagePace) / 60;
    int seconds = static_cast<int>(round(averagePace)) % 60;

    std::cout << "Твой средний темп за тренировку: " << minutes << " минуты " << seconds << " секунд" << std::endl;

    return 0;
}
