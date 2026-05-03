# Module 17.4 — Практическая работа (homework)

**Status:** code готов, 28/28 tests pass, **submit blocked**
**Спецификация:** см. `../../docs/lessons/M17/L4_HWORK.md`
**Solved:** 3/3 mandatory tasks

## Структура

```text
Module17Hwork/
├── README.md
├── test_all.sh                       # batch runner (28 tests)
├── Task1_Swap/                       # void swap(int*, int*)
├── Task2_Reverse/                    # void reverseTen(int*)
└── Task3_Substr/                     # bool substr(const char*, const char*)
```

## Сборка и тестирование

```bash
./test_all.sh                         # all 3 tasks
./Task1_Swap/test.sh                  # one task
```

## Tasks summary

### Task 1 — Swap через указатели

| Параметр   | Значение                                          |
|------------|---------------------------------------------------|
| Алгоритм   | classic temp swap через разыменование             |
| Edge cases | same values, zero, negatives, large numbers       |
| Tests      | 7                                                 |
| Status     | [+] PASS                                          |

### Task 2 — Reverse 10 ints in-place

| Параметр   | Значение                                          |
|------------|---------------------------------------------------|
| Алгоритм   | two-pointer swap (i ↔ N-1-i, до N/2)              |
| Edge cases | palindrome, all-same, negatives, mixed, already   |
| Tests      | 7                                                 |
| Status     | [+] PASS                                          |

### Task 3 — Substr (is substring?)

| Параметр   | Значение                                            |
|------------|-----------------------------------------------------|
| Алгоритм   | naive O(n*m) поиск через strlen + nested loops      |
| Edge cases | empty, longer needle, case-sensitive, repeating, ws |
| Tests      | 14 (spec + edge + классические naive failure cases) |
| Status     | [+] PASS                                            |

## Submission links

| Task | Replit URL                                                                                          |
|------|-----------------------------------------------------------------------------------------------------|
| 1    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module17th/Module17Hwork/Task1_Swap/main.cpp>      |
| 2    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module17th/Module17Hwork/Task2_Reverse/main.cpp>   |
| 3    | <https://replit.com/@SierghieiRiaza1/CppSkillBox#Module17th/Module17Hwork/Task3_Substr/main.cpp>    |

| Task | GitHub URL                                                                                                      |
|------|-----------------------------------------------------------------------------------------------------------------|
| 1    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module17th/Module17Hwork/Task1_Swap/main.cpp>       |
| 2    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module17th/Module17Hwork/Task2_Reverse/main.cpp>    |
| 3    | <https://github.com/MajotraderLucky/CppSkillBox/blob/master/Module17th/Module17Hwork/Task3_Substr/main.cpp>     |
