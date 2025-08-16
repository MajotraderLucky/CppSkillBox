#!/bin/bash

echo "=== Тестирование программы Многоквартирный дом ==="

# Компиляция
echo "Компиляция программы..."
g++ apartment_house.cpp -o apartment_house
if [ $? -ne 0 ]; then
    echo "Ошибка компиляции!"
    exit 1
fi

# Тест 1: Базовый тест из примера
echo -e "\n--- Тест 1: Базовый пример ---"
echo -e "SidorovA\nIvanovA\nPetrovA\nSidorovB\nIvanovB\nPetrovB\nSidorovC\nIvanovC\nPetrovC\nSidorovD\n10\n1\n5" | ./apartment_house > test1_output.txt
echo "Ожидаемый вывод:"
echo "SidorovD"
echo "SidorovA" 
echo "IvanovB"
echo -e "\nПолученный вывод:"
grep -E "(SidorovD|SidorovA|IvanovB)" test1_output.txt || echo "Тест 1 НЕ ПРОЙДЕН"

# Тест 2: Проверка граничных значений
echo -e "\n--- Тест 2: Граничные значения (1 и 10) ---"
echo -e "Tenant1\nTenant2\nTenant3\nTenant4\nTenant5\nTenant6\nTenant7\nTenant8\nTenant9\nTenant10\n1\n10\n5" | ./apartment_house > test2_output.txt
echo "Проверка первой и последней квартиры:"
grep -q "Tenant1" test2_output.txt && grep -q "Tenant10" test2_output.txt && echo "Граничные значения работают корректно" || echo "Тест 2 НЕ ПРОЙДЕН"

# Тест 3: Некорректные номера квартир
echo -e "\n--- Тест 3: Некорректные номера ---"
echo -e "A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\n0\n11\n-1" | ./apartment_house > test3_output.txt
echo "Проверка обработки ошибок:"
grep -q "Ошибка" test3_output.txt && echo "Ошибки обрабатываются корректно" || echo "Тест 3 НЕ ПРОЙДЕН"

# Тест 4: Все квартиры подряд
echo -e "\n--- Тест 4: Проверка всех квартир ---"
echo -e "Fam1\nFam2\nFam3\nFam4\nFam5\nFam6\nFam7\nFam8\nFam9\nFam10\n3\n7\n9" | ./apartment_house > test4_output.txt
grep -q "Fam3" test4_output.txt && grep -q "Fam7" test4_output.txt && grep -q "Fam9" test4_output.txt && echo "Все квартиры доступны корректно" || echo "Тест 4 НЕ ПРОЙДЕН"

# Тест 5: Одинаковые фамилии в разных квартирах
echo -e "\n--- Тест 5: Одинаковые фамилии ---"
echo -e "Ivanov\nPetrov\nIvanov\nSidorov\nIvanov\nPetrov\nSidorov\nIvanov\nPetrov\nSidorov\n1\n3\n8" | ./apartment_house > test5_output.txt
echo "Проверка корректности индексации при одинаковых фамилиях"
# Проверяем, что выводится правильное количество фамилий
count=$(grep -c "Жилец: Ivanov" test5_output.txt)
if [ $count -eq 3 ]; then
    echo "Индексация работает корректно"
else
    echo "Тест 5 НЕ ПРОЙДЕН (ожидалось 3 Ivanov, получено $count)"
fi

# Очистка временных файлов
rm -f test*_output.txt

echo -e "\n=== Тестирование завершено ==="