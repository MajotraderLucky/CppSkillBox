#include <iostream>
#include <string>
#include "usersinputcontrol.h"

int main() {
    double km, sec;

    std::pair<double, bool> userInput;
    userInput = getUserInput(
            "Привет, Сэм! Сколько километров ты сегодня пробежал?-> ",
            0.1, 100,
            "Ошибка: вы ввели некорректные данные. Для завершения программы введите 'stop'\n"
    );

    if (userInput.second) return 0;
    km = userInput.first;

    if (km < 1) {
        userInput = getUserInput(
                "Какой у тебя был темп на этой дистанции " + std::to_string(km) + "?-> ",
                0.1, 1000,
                "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n"
        );
        if (userInput.second) return 0;
        sec = userInput.first;
    } else {
        do {
            userInput = getUserInput(
                    "Какой у тебя был темп на километре " + std::to_string(km) + "?-> ",
                    0.1, 1000,
                    "Ошибка: вы ввели некорректные данные. Для завершения программы введите'stop'\n"
            );
            if (userInput.second) return 0;
            sec = userInput.first;
            --km;
        } while (km > 0);
    }



    std::cout << "Количество километров, которое ты сегодня пробежал: " << km << std::endl;
    std::cout << "Количество секунд, за которые  ты сегодня пробежал дистанцию: " << sec << std::endl;

    return 0;
}