#include <iomanip>
#include <iostream>
#include <vector>

int main() {
    // По условию: цены и покупки задаются напрямую в коде через списки инициализации
    std::vector<float> prices {2.5, 4.25, 3.0, 10.0};
    std::vector<int>   items  {1, 1, 0, 3};

    float total = 0;
    // Один цикл — пробегаем по items, индексируем prices
    for (int idx : items) {
        // Контроль ввода: bounds check (по критерию "не допускает выхода за границы")
        if (idx < 0 || idx >= (int)prices.size()) {
            std::cout << "Error: invalid item index " << idx << std::endl;
            return 1;
        }
        total += prices[idx];
    }

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Total: " << total << std::endl;
    return 0;
}
