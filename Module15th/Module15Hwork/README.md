# Module 15.6 — Практическая работа (homework)

**Status:** code готов, 57/57 tests pass, **submit blocked** (Skillbox support отключён)
**Спецификация:** см. `../../docs/lessons/M15/L6_HWORK.md`
**Solved:** 4/4 mandatory tasks

## Структура

```text
Module15Hwork/
├── README.md (этот файл)
├── test_all.sh                          # batch runner (57 tests total)
├── Task1_MaxSubarray/                   # Kadane's algorithm
│   ├── main.cpp                         # 14 tests
│   └── test.sh
├── Task2_TwoSum/                        # naive O(n²) + early exit
│   ├── main.cpp                         # 14 tests
│   └── test.sh
├── Task3_Top5/                          # online algorithm + memory opt
│   ├── main.cpp                         # 16 tests
│   └── test.sh
└── Task4_AbsSort/                       # two-pointer на pre-sorted
    ├── main.cpp                         # 13 tests
    └── test.sh
```

## Сборка и тестирование

```bash
# Все 4 задачи
./test_all.sh

# Одна задача
./Task1_MaxSubarray/test.sh

# Manual compile
cd Task1_MaxSubarray && g++ -std=c++11 -Wall -Wextra main.cpp -o maxsubarray
./maxsubarray
```

## Tasks summary

### Task 1 — Maximum Subarray (LeetCode 53)

| Параметр       | Значение                                                       |
|----------------|----------------------------------------------------------------|
| Алгоритм       | Kadane's O(n) — single-pass с tracking cur_sum/cur_start/best  |
| Edge cases     | empty, single, all-negative, all-positive, all-zero, ties      |
| Tests          | 14 (spec + position variations + signs + zero + edge sizes)    |
| Status         | [+] PASS                                                       |

### Task 2 — Two Sum (LeetCode 1)

| Параметр       | Значение                                                       |
|----------------|----------------------------------------------------------------|
| Алгоритм       | Naive O(n²) с early-exit при первой паре                       |
| Edge cases     | negative, zero, duplicates, no-pair, n<=1                      |
| Tests          | 14 (positions, signs, zero, dup, no-pair, edge sizes)          |
| Status         | [+] PASS                                                       |

### Task 3 — Top-5 smallest (online algorithm)

| Параметр       | Значение                                                       |
|----------------|----------------------------------------------------------------|
| Алгоритм       | Maintain top-5 sorted vector, drop большие, replace при < max  |
| Edge cases     | <5 elements, 0 elements, multi-query, all-negative, dup        |
| Tests          | 16 (spec ex1+ex2 + validations + multi + signs + dup)          |
| Status         | [+] PASS                                                       |

### Task 4 — Sort by absolute value (two-pointer)

| Параметр       | Значение                                                       |
|----------------|----------------------------------------------------------------|
| Алгоритм       | O(n) two-pointer от границы neg/pos, ties → positive wins      |
| Edge cases     | only-pos, only-neg, with-zero, ties, single, empty, unsorted   |
| Tests          | 13 (spec + sign-only + zero + ties + edge + validation)        |
| Status         | [+] PASS                                                       |

## Соответствие критериям hwork (из L6_HWORK.md)

| Критерий                                   | Status                                 |
|--------------------------------------------|----------------------------------------|
| В циклах нет выхода за границы массивов    | [+]                                    |
| Действия вынесены в функции                | [+] (solve/findPair/insertTop/absSort) |
| Программы запускаются без syntax errors    | [+] g++ -Wall -Wextra                  |
| Имена переменных корректные                | [+]                                    |
| Текстовый интерфейс для всех программ      | [+] (stderr prompts)                   |
| Контроль ввода                             | [+] (size/value validation)            |
| Использован оптимальный алгоритм           | [+] (Kadane, top-5 maintain, two-ptr)  |
| Выполнены все 4 задания                    | [+] (4/4)                              |

## Submission links для преподавателя

Replit (тот же паттерн что использовался для M12/M13.6/M14.6):

| Task | Replit URL                                                                                                  |
|------|-------------------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module15th/Module15Hwork/Task1_MaxSubarray/main.cpp>       |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module15th/Module15Hwork/Task2_TwoSum/main.cpp>            |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module15th/Module15Hwork/Task3_Top5/main.cpp>              |
| 4    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module15th/Module15Hwork/Task4_AbsSort/main.cpp>           |

Backup (GitHub blob URLs):

| Task | GitHub URL                                                                                                       |
|------|------------------------------------------------------------------------------------------------------------------|
| 1    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module15th/Module15Hwork/Task1_MaxSubarray/main.cpp> |
| 2    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module15th/Module15Hwork/Task2_TwoSum/main.cpp>      |
| 3    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module15th/Module15Hwork/Task3_Top5/main.cpp>        |
| 4    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module15th/Module15Hwork/Task4_AbsSort/main.cpp>     |
