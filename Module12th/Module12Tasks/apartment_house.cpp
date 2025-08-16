#include <iostream>
#include <string>

int main() {
    const int APARTMENTS_COUNT = 10;
    std::string tenants[APARTMENTS_COUNT];
    
    // Ввод фамилий жильцов
    std::cout << "Введите фамилии жильцов 10 квартир:" << std::endl;
    for (int i = 0; i < APARTMENTS_COUNT; ++i) {
        std::cout << "Квартира " << (i + 1) << ": ";
        std::cin >> tenants[i];
    }
    
    // Запрос трех номеров квартир
    std::cout << "\nВведите 3 номера квартир для поиска жильцов:" << std::endl;
    for (int i = 0; i < 3; ++i) {
        int apartmentNumber;
        std::cout << "Номер квартиры: ";
        std::cin >> apartmentNumber;
        
        // Проверка корректности номера квартиры
        if (apartmentNumber >= 1 && apartmentNumber <= APARTMENTS_COUNT) {
            // Индекс массива = номер квартиры - 1
            std::cout << "Жилец: " << tenants[apartmentNumber - 1] << std::endl;
        } else {
            std::cout << "Ошибка: некорректный номер квартиры (должен быть от 1 до " 
                      << APARTMENTS_COUNT << ")" << std::endl;
        }
    }
    
    return 0;
}