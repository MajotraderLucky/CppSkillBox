// M23.4 Task 2 — Время года через #if/#endif.
// Программист определяет один из SPRING/SUMMER/AUTUMN/WINTER
// в коде или через -DSEASON_NAME при компиляции.
//
// Тестируем через -DSEASON_NAME (test.sh подставляет нужный флаг).

#include <iostream>

#if defined(SPRING)
int main() { std::cout << "Spring\n"; return 0; }
#elif defined(SUMMER)
int main() { std::cout << "Summer\n"; return 0; }
#elif defined(AUTUMN)
int main() { std::cout << "Autumn\n"; return 0; }
#elif defined(WINTER)
int main() { std::cout << "Winter\n"; return 0; }
#else
int main() {
    std::cerr << "Сезон не выбран. Укажите -DSPRING/SUMMER/AUTUMN/WINTER\n";
    return 1;
}
#endif
