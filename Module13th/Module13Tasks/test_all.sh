#!/bin/bash

PASSED=0
FAILED=0
TOTAL=0

check() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local expected="$2"
    local actual="$3"
    if echo "$actual" | grep -qF -- "$expected"; then
        echo "  ПРОЙДЕН: $name"
        PASSED=$((PASSED + 1))
    else
        echo "  НЕ ПРОЙДЕН: $name"
        echo "    Ожидалось: $expected"
        echo "    Получено:  $actual"
        FAILED=$((FAILED + 1))
    fi
}

DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================================
echo "=== Компиляция всех заданий ==="
# ============================================================
g++ -std=c++11 "$DIR/Task1_Average/main.cpp" -o "$DIR/Task1_Average/average" || exit 1
g++ -std=c++11 "$DIR/Task2_Reverse/main.cpp" -o "$DIR/Task2_Reverse/reverse" || exit 1
g++ -std=c++11 "$DIR/Task3_SecondMax/main.cpp" -o "$DIR/Task3_SecondMax/second_max" || exit 1
g++ -std=c++11 "$DIR/Task4_RobotQueue/main.cpp" -o "$DIR/Task4_RobotQueue/robot_queue" || exit 1
g++ -std=c++11 "$DIR/Task5_Hospital/main.cpp" -o "$DIR/Task5_Hospital/hospital" || exit 1
g++ -std=c++11 "$DIR/Task6_RobotCorruption/main.cpp" -o "$DIR/Task6_RobotCorruption/robot_corruption" || exit 1
echo "Компиляция успешна."
echo

# ============================================================
echo "=== Task 1: Среднее арифметическое ==="
# ============================================================
T1="$DIR/Task1_Average/average"

out=$(echo "5 10 20 30 40 50" | $T1)
check "5 чисел (10,20,30,40,50) -> 30" "Average: 30" "$out"

out=$(echo "3 -5 0 5" | $T1)
check "3 числа (-5,0,5) -> 0" "Average: 0" "$out"

out=$(echo "4 1 2 3 4" | $T1)
check "4 числа (1,2,3,4) -> 2.5" "Average: 2.5" "$out"

out=$(echo "1 42" | $T1)
check "1 число (42) -> 42" "Average: 42" "$out"

out=$(echo "3 -10 -20 -30" | $T1)
check "Отрицательные (-10,-20,-30) -> -20" "Average: -20" "$out"

out=$(echo "3 5 5 5" | $T1)
check "Одинаковые (5,5,5) -> 5" "Average: 5" "$out"

out=$(echo "2 1000000 1000000" | $T1)
check "Большие числа -> 1e+06" "Average: 1e+06" "$out"

out=$(echo "2 0 0" | $T1)
check "Нули (0,0) -> 0" "Average: 0" "$out"
echo

# ============================================================
echo "=== Task 2: Обратный порядок ==="
# ============================================================
T2="$DIR/Task2_Reverse/reverse"

out=$(echo "5 1.1 2.2 3.3 4.4 5.5" | $T2)
check "5 дробных -> 5.5 4.4 3.3 2.2 1.1" "5.5 4.4 3.3 2.2 1.1" "$out"

out=$(echo "3 10.5 20.3 30.1" | $T2)
check "3 дробных -> 30.1 20.3 10.5" "30.1 20.3 10.5" "$out"

out=$(echo "1 7.77" | $T2)
check "1 число -> 7.77" "7.77" "$out"

out=$(echo "4 0 0 0 0" | $T2)
check "Все нули -> 0 0 0 0" "0 0 0 0" "$out"

out=$(echo "3 -1.5 2.5 -3.5" | $T2)
check "Отрицательные -> -3.5 2.5 -1.5" "-3.5 2.5 -1.5" "$out"

out=$(echo "2 3.14 2.71" | $T2)
check "Два дробных -> 2.71 3.14" "2.71 3.14" "$out"

out=$(echo "3 1 2 3" | $T2)
check "Целые как дробные -> 3 2 1" "3 2 1" "$out"
echo

# ============================================================
echo "=== Task 3: Второй максимум ==="
# ============================================================
T3="$DIR/Task3_SecondMax/second_max"

out=$(echo "5 10 20 30 40 50" | $T3)
check "5 чисел -> второй: 40" "Second largest: 40" "$out"

out=$(echo "4 5 5 3 1" | $T3)
check "Дубликаты (5,5,3,1) -> второй: 3" "Second largest: 3" "$out"

out=$(echo "4 -1 -5 -2 -3" | $T3)
check "Отрицательные -> второй: -2" "Second largest: -2" "$out"

out=$(echo "2 100 200" | $T3)
check "Два числа (100,200) -> второй: 100" "Second largest: 100" "$out"

out=$(echo "5 1 2 3 4 5" | $T3)
check "Последовательность 1-5 -> второй: 4" "Second largest: 4" "$out"

out=$(echo "3 7 7 7" | $T3)
check "Все одинаковые (7,7,7) -> INT_MIN" "Second largest:" "$out"

out=$(echo "5 5 4 3 2 1" | $T3)
check "Убывающая (5,4,3,2,1) -> второй: 4" "Second largest: 4" "$out"

out=$(echo "2 10 10" | $T3)
check "Два одинаковых (10,10) -> INT_MIN" "Second largest:" "$out"

out=$(echo "3 1 2 2" | $T3)
check "Дубликат максимума (1,2,2) -> второй: 1" "Second largest: 1" "$out"
echo

# ============================================================
echo "=== Task 4: Очередь роботов ==="
# ============================================================
T4="$DIR/Task4_RobotQueue/robot_queue"

out=$(echo "101 202 303 0" | $T4)
check "3 робота -> порядок сохранен" "1. Robot #101" "$out"
check "3 робота -> последний 303" "3. Robot #303" "$out"

out=$(echo "42 0" | $T4)
check "1 робот -> Robot #42" "1. Robot #42" "$out"

out=$(echo "0" | $T4)
# Пустая очередь — нет роботов в выводе
result=$(echo "$out" | grep -c "Robot")
if [ "$result" -eq 0 ]; then
    echo "  ПРОЙДЕН: Пустая очередь — нет роботов"
    PASSED=$((PASSED + 1))
else
    echo "  НЕ ПРОЙДЕН: Пустая очередь — не должно быть роботов"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo

# ============================================================
echo "=== Task 5: Лечебница ==="
# ============================================================
T5="$DIR/Task5_Hospital/hospital"

out=$(echo "25 30 45 60 -1" | $T5)
check "4 пациента (25,30,45,60) -> Count: 4" "Count: 4" "$out"
check "4 пациента -> Average age: 40" "Average age: 40" "$out"

out=$(echo "70 -1" | $T5)
check "1 пациент (70) -> Count: 1" "Count: 1" "$out"
check "1 пациент (70) -> Average age: 70" "Average age: 70" "$out"

out=$(echo "-1" | $T5)
check "Нет пациентов -> No patients" "No patients" "$out"

out=$(echo "10 20 30 -1" | $T5)
check "3 пациента (10,20,30) -> Average age: 20" "Average age: 20" "$out"

out=$(echo "25 30 -1" | $T5)
check "Дробное среднее (25,30) -> Average age: 27.5" "Average age: 27.5" "$out"

out=$(echo "1 100 -1" | $T5)
check "Крайние возрасты (1,100) -> Count: 2" "Count: 2" "$out"
echo

# ============================================================
echo "=== Task 6: Роботы и коррупция ==="
# ============================================================
T6="$DIR/Task6_RobotCorruption/robot_corruption"

# Тест: добавить 3 робота, вставить на позицию 2
out=$(printf "add\n101\nadd\n202\nadd\n303\ninsert\n999\n2\nshow\nquit\n" | $T6)
check "Insert на позицию 2 -> Robot #999 на 2 месте" "2. Robot #999" "$out"
check "Старый 2-й сдвинулся на 3 -> Robot #202" "3. Robot #202" "$out"
check "Старый 3-й сдвинулся на 4 -> Robot #303" "4. Robot #303" "$out"

# Тест: вставить на позицию 1 (в начало)
out=$(printf "add\n100\nadd\n200\ninsert\n50\n1\nshow\nquit\n" | $T6)
check "Insert на позицию 1 -> Robot #50 первый" "1. Robot #50" "$out"

# Тест: только добавление в конец
out=$(printf "add\n10\nadd\n20\nadd\n30\nshow\nquit\n" | $T6)
check "Порядок добавления -> 10, 20, 30" "1. Robot #10" "$out"
check "Порядок добавления -> последний 30" "3. Robot #30" "$out"

# Тест: insert в конец (позиция > размера)
out=$(printf "add\n100\nadd\n200\ninsert\n300\n10\nshow\nquit\n" | $T6)
check "Insert за пределы -> Robot #300 в конце" "3. Robot #300" "$out"

# Тест: insert в пустую очередь
out=$(printf "insert\n42\n1\nshow\nquit\n" | $T6)
check "Insert в пустую очередь -> Robot #42" "1. Robot #42" "$out"
echo

# ============================================================
echo "=========================================="
echo "Итого: $PASSED из $TOTAL тестов пройдено"
if [ $FAILED -gt 0 ]; then
    echo "Не пройдено: $FAILED"
fi
echo "=========================================="
