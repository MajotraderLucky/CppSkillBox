#include <iostream>
#include <limits>
#include <string>

bool validateInput(const std::string& input) {
    try {
        double value = std::stod(input);
        if (value < 0 || value > 1) {
            return false;
        }
    } catch (std::exception&) {
        return false;
    }

    return true;
}

int main() {
    double health;
    double resistance;

    // Ввод данных пользователя
    std::cout << "Введите количество здоровья орка (от 0 до 1): ";
    std::string inputHealth;
    std::getline(std::cin, inputHealth);

    // Проверка на корректность введенного значения здоровья
    if (!validateInput(inputHealth)) {
        std::cout << "Ошибка! Количество здоровья должно быть числом от 0 до 1. Программа завершена.\n";
        return 0;
    }

    health = std::stod(inputHealth);

    // Ввод сопротивляемости магии орка
    std::cout << "Введите сопротивляемость магии орка (от 0 до 1): ";
    std::string inputResistance;
    std::getline(std::cin, inputResistance);

    // Проверка на корректность введенного значения сопротивляемости магии
    if (!validateInput(inputResistance)) {
        std::cout << "Ошибка! Сопротивляемость магии должна быть числом от 0 до 1. Программа завершена.\n";
        return 0;
    }

    resistance = std::stod(inputResistance);

    bool orcAlive = true;

    while (health > 0 && orcAlive) {
        // Ввод мощности удара
        std::cout << "Введите мощность огненного шара (от 0 до 1): ";
        std::string inputPower;
        std::getline(std::cin, inputPower);

        // Проверка введенной мощности удара
        if (!validateInput(inputPower)) {
            std::cout << "Ошибка! Мощность должна быть числом от 0 до 1. Попробуйте ещё раз или введите 'стоп' для завершения программы.\n";

            // Проверка на ввод строки "стоп"
            std::string userInput;
            std::getline(std::cin, userInput);
            if (userInput == "стоп") {
                std::cout << "Программа завершена." << std::endl;
                return 0;
            }
            continue;
        }

        double power = std::stod(inputPower);

        // Расчет урона с учетом сопротивляемости магии
        double damage = power * (1 - resistance);

        // Нанесение урона орку
        health -= damage;

        // Проверка на возможность сопротивления магии
        if (health < 0) {
            health = 0;
            orcAlive = false;
        }

        // Вывод результатов
        std::cout << "Нанесенный урон: " << damage << std::endl;
        std::cout << "Оставшиеся очки здоровья орка: " << health << std::endl;
    }

    if (orcAlive) {
        std::cout << "Орк погиб!" << std::endl;
    } else {
        std::cout << "Программа завершена." << std::endl;
    }

    return 0;
}
