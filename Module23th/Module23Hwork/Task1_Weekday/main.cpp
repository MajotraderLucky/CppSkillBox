// M23.4 Task 1 — Дни недели на макросах.
// Spec: ввод порядкового номера → буквенное название.
// Запрещены: классические переменные (кроме хранения ввода) и
// строковые литералы напрямую.
// Используем token-pasting ## + раскрытие макросов.

#include <iostream>

#define DAY_1 "Monday"
#define DAY_2 "Tuesday"
#define DAY_3 "Wednesday"
#define DAY_4 "Thursday"
#define DAY_5 "Friday"
#define DAY_6 "Saturday"
#define DAY_7 "Sunday"

// Двухступенчатое раскрытие — ОБЯЗАТЕЛЬНО для ##.
// Без этого аргумент не раскроется до подстановки.
#define DAY_NAME_PASTE(n) DAY_##n
#define DAY_NAME(n)       DAY_NAME_PASTE(n)

#define PROMPT  "День недели (1-7): "
#define INVALID "Неверный номер"

int main() {
    int n;
    std::cerr << PROMPT;
    if (!(std::cin >> n)) return 1;

    switch (n) {
        case 1: std::cout << DAY_NAME(1) << "\n"; break;
        case 2: std::cout << DAY_NAME(2) << "\n"; break;
        case 3: std::cout << DAY_NAME(3) << "\n"; break;
        case 4: std::cout << DAY_NAME(4) << "\n"; break;
        case 5: std::cout << DAY_NAME(5) << "\n"; break;
        case 6: std::cout << DAY_NAME(6) << "\n"; break;
        case 7: std::cout << DAY_NAME(7) << "\n"; break;
        default: std::cout << INVALID << "\n"; return 2;
    }
    return 0;
}
