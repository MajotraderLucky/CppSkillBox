#include <iostream>
#include <string>
#include <complex>
#include "usersinputcontrol.h"

int main() {
    double fileSize, speedConnect;

    std::pair<double, bool> userInput;

    userInput = getUserInput(
            "Укажите размер файла для скачивания в мегабайтах: ",
            0.001, 1000000000,
            "Ошибка: вы указали некорректный размер файла. Для завершения программы введите 'stop'\n"
);
    if (userInput.second) return 0;
    fileSize = userInput.first;

    userInput = getUserInput(
            "Укажите скорость соединения мегабайт/сек: ",
            0.001, 1000000000,
            "Ошибка: вы указали некорректную скорость соединения. Для завершения программы введите'stop'\n"
    );
    if (userInput.second) return 0;
    speedConnect = userInput.first;

    std::cout << "Скачиваем файл с размером " << fileSize << std::endl;
    std::cout << "Скорость соединения: " << speedConnect << std::endl;

    double downloaded = 0;
    int seconds = 0;
    while (downloaded < fileSize) {
        downloaded += speedConnect;
        if (downloaded > fileSize) {
            downloaded = fileSize;
        }

        int percentage = static_cast<int>((downloaded / fileSize) * 100);
        std::cout << "Прошло " << ++seconds << " сек. Скачано " << downloaded << " из " << fileSize << " МБ (" << percentage << "%)." << std::endl;
    }

    std::cout << "Файл загружен полностью за " << seconds << " секунд." << std::endl;


    return 0;
}
